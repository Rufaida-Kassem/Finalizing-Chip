module full_adder (  
		  input a, b,  
                  input Cin, 
		  output S ,
                  output Cout
                  );  
 wire s0,c0,c1;
 assign s0 = a^b;
 assign c0 = a&b;
 assign S = s0 ^ Cin;
 assign Cout = (s0 & Cin) | c0;
endmodule  

module CLA_4bit(
   input [3:0] x,
   input [3:0] y,   
   input cO,
   output [3:0]  s,
   output p,g
);
assign s = x+y+cO;
assign g = 
(x[3]&y[3])|
(x[2]&y[2]&(x[3]|y[3]))|
(x[0]&y[0]&(x[3]|y[3])&(x[2]|y[2]))|
(x[0]&y[0]&(x[3]|y[3])&(x[2]|y[2])&(x[1]|y[1]));
assign p = (x[3]|y[3])&(x[2]|y[2])&(x[1]|y[1])&(x[0]|y[0]) ;
endmodule

module CLA_adder
  #(parameter WIDTH = 32)
  (
   input [WIDTH-1:0] A,
   input [WIDTH-1:0] B,   
   input Cin,
   output [WIDTH-1:0]  Sum,
   output Cout,
   output Overflow
   );
  wire [(WIDTH/4):0]   Cin_P;
  wire [(WIDTH/4)-1:0]   w_G, w_P;
  
  



  genvar j;
  generate
    for (j=0; j < WIDTH/4; j=j+1) 
      begin
	      CLA_4bit stage1(A[3+j*4:j*4],B[3+j*4:j*4],Cin_P[j],Sum[3+j*4:j*4],w_P[j],w_G[j]);
        assign Cin_P[j+1] = w_G[j] | (w_P[j] & Cin_P[j]);
      end
  endgenerate
  
  assign Cin_P[0] = Cin; 
  assign Cout = Cin_P[(WIDTH/4)];   
  assign Overflow = ~(A[WIDTH - 1] ^ B[WIDTH - 1]) & (A[WIDTH - 1] ^ Sum[WIDTH - 1]);

endmodule