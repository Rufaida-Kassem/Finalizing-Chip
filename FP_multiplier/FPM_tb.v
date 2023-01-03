module FPM_tb();
  reg clk, en, reset;
  reg [31:0] a;
  reg [31:0] b;
  reg [31:0]expected;
  wire [31:0] product;
  wire overflow;
  FloatingPointMultiplierSingle 
  FloatingPointMultiplierSingle_dut (
    .clk (clk ),
    .reset (reset ),
    .en (en ),
    .inputA (a ),
    . inputB ( b ),
    .result (product ),
    .OF  ( overflow)
  );

  integer test_no = 1;
  parameter clk_period = 4;

  always  begin
    #2 clk = ~clk;
  end

  initial
  begin
    clk=0;
    reset=1; //Clock low at time zero
    en = 1;
    #(2 * clk_period);
    reset = 0;

    //1.+ve * +ve
    a= 32'b0_10000100_00000011001100110011001; //32.4
    b= 32'b0_10000010_01001001100110011001100; //10.3
    expected = 32'b0_10000111_01001101101110000101000;//42.7
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;

    //2.+ve * +ve
    a= 32'b0_10000110_00001000011111110111110; //132.249
    b= 32'b0_10000011_00111110101110000101000; //19.92
    expected = 32'b0_10001010_01001001010011001100110;//2634.40008
    #(2 * clk_period)
     if((product == expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin //152.6
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;

    //3.-ve + +ve positive result
    a= 32'b11000010000001111100001010001111; //-33.94
    b= 32'b01000010010000111011100001010010; //48.93
    expected = 32'b11000100110011111001010111100100;//-1660.6842
    #(2 * clk_period)
     if((product == expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;


    //4.+ve + -ve negative result
    a= 32'b01000010000001111100001010001111; //33.94
    b= 32'b11000010010000111011100001010010; //-48.93
    expected = 32'b11000100110011111001010111100100;//-1660.6842
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;


    //5.-ve * -ve
    a= 32'b11000001011101011100001010001111; //-15.36
    b= 32'b11000001110001001100110011001100; //-24.6
    expected = 32'b01000011101111001110110110010001;//377.856
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;

    //6.-ve * -ve
    a= 32'b10111111100111010111000010100011; //-1.23
    b= 32'b11000001101101000010100011110101; //-22.52
    expected = 32'b01000001110111011001100011000111;//27.6996
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;

    //7.testing NUMBER * 0
    a= 32'b11000010010000111011100001010010; //-48.93
    b= 32'b0; //0
    expected = 32'b10000000000000000000000000000000; //0 with sign flag 1
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;

    //8.tesing 0 * NUMBER = 0
    b= 32'b11000010010000111011100001010010; //-48.93
    a= 32'b0; //0
    expected = 32'b10000000000000000000000000000000; //0 with sign flag 1
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;
    //tesing 0 * inf = nan
    b= 32'b0_11111111_00000000000000000000000; //infinity
    a= 32'b0; //0
    expected = 32'b0_11111111_1111_1111_1111_1111_1111_111; //0 with sign flag 1
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;

    //9.tesing the overflow
    b= 32'b0_11000001_01011010111100011101011; //-48.93
    a= 32'b0_11000001_01011010111100011101011; //0
    expected = product; //0 with sign flag 1
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;

    //10.tesing infinity * number = infinity
    b= 32'b0_11111111_00000000000000000000000; //infinity
    a= 32'b0_11000001_01011010111100011101011; //0
    expected = 32'b0_11111111_00000000000000000000000; //0 with sign flag 1
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;
    //11.tesing nan * number = nan
    b= 32'b0_11111111_11111111111111111111111; //infinity
    a= 32'b0_11000001_01011010111100011101011; //0
    expected = 32'b0_11111111_11111111111111111111111; //0 with sign flag 1
    #(2 * clk_period)
     if((product==expected || product + 1'b1 == expected|| product - 1'b1 == expected) && overflow == 0)
     begin
       $display("Test case %d PASSED SUCCESSFULY!\n", test_no);
     end
     else
     begin
       $display ("Test case %d FAILED\n", test_no);
       $display("expected product = %b\nactual  product  = %b\nOver flow = %b\n\n ",expected, product,overflow);
     end
     test_no = test_no + 1;

  end
endmodule
