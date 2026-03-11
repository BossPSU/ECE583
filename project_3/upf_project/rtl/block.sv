// =====================================================
// block.sv
// Power-gated toggle block
// NOTE: Students must NOT modify this file
// =====================================================

module block (
    input  logic clk,
    input  logic rst_n,
    output logic d
);

    // Simple toggle flip-flop
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            d <= 1'b0;
        else
            d <= ~d;
    end

endmodule
