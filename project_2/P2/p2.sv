module p2 (
    input  logic CLK,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic a
);
  logic s;
  assign s = (~c) & (b | (~d));     // s = cbar*(b + dbar)
  always_ff @(posedge CLK) begin
    a <= ~(a ^ s);                  // a_next = XNOR(a, s)
  end
endmodule
