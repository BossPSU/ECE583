// =====================================================
// top.sv
// Always-on top module
// NOTE: Students must NOT modify this file
// =====================================================

module top (
    input  logic clk,
    input  logic rst_n,

    // Power management controls (driven by testbench)
    input  logic pwr_en,        // Power switch enable
    input  logic iso_ctrl,      // Isolation enable
    input  logic save_ctrl,     // Retention save
    input  logic restore_ctrl,  // Retention restore

    output logic out
);

    // Internal signal from power-gated block
    logic d_block;

    // -------------------------------------------------
    // Power-gated block instance
    // -------------------------------------------------
    block u_block (
        .clk   (clk),
        .rst_n (rst_n),
        .d     (d_block)
    );

    // -------------------------------------------------
    // NOTE:
    // - No isolation logic here
    // - No level shifter here
    // - No retention logic here
    // All power behavior is described in UPF
    // -------------------------------------------------

    assign out = d_block;

endmodule
