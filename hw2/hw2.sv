`timescale 1ns/1ps
module hw2 (
    input  logic a, b, c, d,
    output logic o1, o2, f
);

    assign #1 o1 = a & b;
    assign #1 o2 = o1 & c;
    assign #1 f  = o2 & d;

endmodule
