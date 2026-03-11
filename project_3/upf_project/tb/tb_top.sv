// =====================================================
// tb_top.sv
// Testbench for UPF-based power-gated toggle block
// =====================================================
import UPF::*;

module tb_top;

    // Clock & reset
    logic clk;
    logic rst_n;

    // Power management controls
    logic pwr_en;
    logic iso_ctrl;
    logic save_ctrl;
    logic restore_ctrl;
	
	logic status;

    // DUT output
    logic out;

    // -------------------------------------------------
    // Instantiate DUT
    // -------------------------------------------------
    top dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .pwr_en       (pwr_en),
        .iso_ctrl     (iso_ctrl),
        .save_ctrl    (save_ctrl),
        .restore_ctrl (restore_ctrl),
        .out          (out)
    );

    // -------------------------------------------------
    // Clock generation: 10 ns period
    // -------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // -------------------------------------------------
    // Test sequence
    // -------------------------------------------------
    initial begin
        $display("=== UPF Power-Gated Block Simulation Start ===");

        // 1. Initial State: Power ON
        supply_on("/dut/VDD_AO", 1.0);
        supply_on("/dut/VDD_PG", 0.8);
        status = supply_on("/dut/VSS", 0);
        
        // Drive initial values on negedge
        @(negedge clk);
        rst_n        = 0;
        pwr_en       = 1;
        iso_ctrl     = 0;
        save_ctrl    = 0;
        restore_ctrl = 0;

        // Release reset after a few cycles
        repeat (5) @(negedge clk);
        rst_n = 1;
        repeat (5) @(negedge clk);

        // ---------------------------------------------
        // Save state: Driven on negedge, sampled by DUT on posedge
        // ---------------------------------------------
        $display("---- Saving retention state ----");
        @(negedge clk);
        save_ctrl = 1;
        @(negedge clk);
        save_ctrl = 0;

        // ---------------------------------------------
        // Power OFF sequence
        // ---------------------------------------------
        $display("---- PD_BLOCK OFF: isolation active ----");
        @(negedge clk);
        iso_ctrl = 1;    // Enable isolation
        
        @(negedge clk);
        pwr_en   = 0;    // Cut power
        
        repeat (10) @(negedge clk);

        // ---------------------------------------------
        // Power ON sequence: PWR -> RESTORE -> ISO
        // ---------------------------------------------
        $display("---- PD_BLOCK ON: restore state ----");
        @(negedge clk);
        pwr_en = 1;      // 1. Restore power
        
        repeat (2) @(negedge clk); 
        
        $display("---- Triggering Restore Pulse ----");
        restore_ctrl = 1; // 2. Pulse restore while ISO is active
        @(negedge clk);
        restore_ctrl = 0;
        
        @(negedge clk);
        iso_ctrl = 0;     // 3. Release isolation

        repeat (10) @(negedge clk);

        $display("=== Simulation Complete ===");
        $finish;
    end

    // -------------------------------------------------
    // Monitor key signals
    // -------------------------------------------------
    initial begin
        $monitor(
            "T=%0t | pwr_en=%b iso=%b save=%b restore=%b | out=%b",
            $time, pwr_en, iso_ctrl, save_ctrl, restore_ctrl, out
        );
    end

endmodule
