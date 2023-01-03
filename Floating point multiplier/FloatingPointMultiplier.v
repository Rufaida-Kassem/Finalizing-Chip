module FloatingPointMultiplier (A, B, O, OF);
  input [31:0] A, B;
  output [31:0] O;
  output OF;
  wire [7:0] a_exponent;
  wire [23:0] a_mantissa;
  wire [7:0] b_exponent;
  wire [23:0] b_mantissa;
  wire isNormalised;
  // Output mantessa normalized after multiplying a_mantissa * b_mantissa
  wire [47:0] o_mantissa_normalised;
  // Output mantessa after rounding
  wire [23:0] O_final_mantessa;

  wire o_sign;
  // Output exponent
  wire [7:0]  o_exponent;//8 bits
  wire o_carry_exponent;
  // Output mantessa not normalized
  wire [47:0] o_mantissa;
  // Zero flag
  wire zf;
  //infinity flag
  wire inf;
  //NAN flag
  wire nan;

  wire a_sign;
  wire b_sign;
  assign a_sign = A[31];
  assign a_exponent = A[30:23];//8bits
  assign a_mantissa = {1'b1,A[22:0]};

  assign b_sign = B[31];
  assign b_exponent = B[30:23];
  assign b_mantissa = {1'b1,B[22:0]};

  assign round = |o_mantissa[22:0];
  assign o_mantissa = a_mantissa * b_mantissa;
  assign {o_carry_exponent,o_exponent} = a_exponent + b_exponent - 8'd127 + isNormalised;
  assign o_sign = A[31] ^ B[31];


  assign isNormalised = o_mantissa[47] ? 1'b1 : 1'b0;
  assign o_mantissa_normalised = isNormalised ? o_mantissa : o_mantissa << 1;
  assign O_final_mantessa = o_mantissa_normalised[46:24] + (o_mantissa_normalised[23] & round); 					// Mantissa

  assign zf = ((a_mantissa[22:0] == 23'b0 && a_exponent==8'b0) || (b_mantissa[22:0] == 23'b0 && b_exponent==8'b0)) ? 1'b1 :  1'b0;
  assign inf = ((a_mantissa[22:0] == 23'b0 && a_exponent==8'hff) || (b_mantissa[22:0] == 23'b0 && b_exponent==8'hff)) ? 1'b1 :  1'b0;
  assign nan = (zf & inf)||((a_mantissa[22:0] != 23'b0 && a_exponent==8'hff) || (b_mantissa[22:0] != 23'b0 && b_exponent==8'hff)) ;
  //if one of the operands is zero and the other is infinity then the result is NaN or if one of the operands is NaN then the result is NaN

  assign O[31] = o_sign;
  assign O[30:23] = nan?8'hff:
         zf ? 0 :
         inf ? 8'hff:
         o_exponent;
  assign O[22:0] = nan ? 23'b1111_1111_1111_1111_1111_111:
         zf ? 0 :
         inf ? 23'b0:
         O_final_mantessa[22:0];
  assign OF = (inf|zf|nan)?0: o_carry_exponent;

  /*
  EXPONENT MANTISA	VALUE
  0		0		exact 0
  255		0		Infinity
  0		not 0	denormalised
  255		not 0	Not a number (NAN)
  */
endmodule
