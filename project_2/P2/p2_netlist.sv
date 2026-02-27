/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : X-2025.06-SP4
// Date      : Thu Feb 26 21:23:46 2026
/////////////////////////////////////////////////////////////


module p2 ( CLK, b, c, d, a );
  input CLK, b, c, d;
  output a;
  wire   n3, n4, n5;

  DFFPOSX1 a_reg ( .D(n3), .CLK(CLK), .Q(a) );
  XNOR2X1 U6 ( .A(a), .B(n4), .Y(n3) );
  AOI21X1 U7 ( .A(d), .B(n5), .C(c), .Y(n4) );
  INVX1 U8 ( .A(b), .Y(n5) );
endmodule

