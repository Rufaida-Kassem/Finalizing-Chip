`include "FloatingPoint.v"
module FPA_tb();
  reg clk, en, reset;
  reg [31:0] a;
  reg [31:0] b;
  reg [31:0]expected;
  wire [31:0] sum;
  wire overflow;
  fpa_with_regisers fpa (clk,reset,en,a, b, sum, overflow);
  integer test_no = 1;
  always
  begin
    #1 clk = ~clk;
  end
  parameter clk_period = 2;

  initial
  begin
    clk=0;
    reset=1; //Clock low at time zero
    en = 1;
    #(2 * clk_period)
     reset = 0;

    //+ve + +ve
    a= 32'b0_10000100_00000011001100110011001; //32.4
    b= 32'b0_10000010_01001001100110011001100; //10.3
    expected = 32'b0_10000100_01010101100110011001100;//42.7
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;

    //+ve + +ve
    a= 32'b0_10000110_00001000011111110111110; //132.249
    b= 32'b0_10000011_00111110101110000101000; //19.92
    expected = 32'b0_10000110_00110000010101101000011;//152.6
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin //152.6
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;

    //-ve + +ve positive result
    a= 32'b11000010000001111100001010001111; //-33.94
    b= 32'b01000010010000111011100001010010; //48.93
    expected = 32'b01000001011011111101011100001000;//14.99
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;


    //+ve + -ve negative result
    a= 32'b01000010000001111100001010001111; //33.94
    b= 32'b11000010010000111011100001010010; //-48.93
    expected = 32'b11000001011011111101011100001000;//-14.99
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;


    //-ve + -ve
    a= 32'b11000001011101011100001010001111; //-15.36
    b= 32'b11000001110001001100110011001100; //-24.6
    expected = 32'b11000010000111111101011100001001;//-39.96
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;

    //-ve + -ve
    a= 32'b10111111100111010111000010100011; //-1.23
    b= 32'b11000001101101000010100011110101; //-22.52
    expected = 32'b11000001101111011111111111111111;//-23.75
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;

    //testing infinity
    a= 32'b01111111100000000000000000000000; //infinity
    b= 32'b11000001101101000010100011110101; //-22.52
    expected = 32'b01111111100000000000000000000000;//infinity
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;

    //testing NaN
    a= 32'b01111111100000000000000000000001; //NaN
    b= 32'b11000010010000111011100001010010; //-48.93
    expected = 32'b01111111100000000000000000000001;//NaN
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;

    //testing NUMBER + 0
    a= 32'b11000010010000111011100001010010; //48.93
    b= 32'b0; //0
    expected = 32'b11000010010000111011100001010010; //48.93
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;

    //tesing 0 + NUMBER
    b= 32'b11000010010000111011100001010010; //48.93
    a= 32'b0; //0
    expected = 32'b11000010010000111011100001010010; //48.93
    #(2 * clk_period)
     if(sum==expected && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected sum = %b\nactual  sum  = %b\nOver flow = %b\n\n ",expected, sum,overflow);
     end
     test_no = test_no + 1;

  end
endmodule
