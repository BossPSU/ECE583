// =============================================================================
// Module  : hw2_tb
// Purpose : Testbench demonstrating ALL glitches from slides 12 and 13.
//
// Slide 12 — Switching Activity on o2
//   T  (initial) : a=1, b=1, c=0, d=0  =>  o1=1, o2=0, f=0
//   3 T+1 vectors each produce a glitch spike on o2
//
// Slide 13 — Switching Activity on f
//   T  (initial) : a=1, b=1, c=1, d=0  =>  o1=1, o2=1, f=0
//   7 T+1 vectors each produce a glitch spike on f
//
// The *_real signals use zero-delay continuous assigns so the waveform
// viewer can overlay the "ideal" (glitch-free) output alongside the
// delayed DUT output, making the glitch pulses clearly visible.
// =============================================================================

`timescale 1ns/1ps

module hw2_tb;

    // ── DUT ports ─────────────────────────────────────────────────────────────
    logic a, b, c, d;
    logic o1, o2, f;

    // ── Zero-delay reference (ideal, glitch-free) ────────────────────────────
    logic o1_real, o2_real, f_real;
    assign o1_real = a & b;
    assign o2_real = o1_real & c;
    assign f_real  = o2_real & d;

    // ── DUT instantiation ────────────────────────────────────────────────────
    hw2 dut (
        .a  (a),
        .b  (b),
        .c  (c),
        .d  (d),
        .o1 (o1),
        .o2 (o2),
        .f  (f)
    );

    // ── Monitor ──────────────────────────────────────────────────────────────
    initial begin
        $monitor("t=%3t  a=%b b=%b c=%b d=%b | o1=%b o2=%b f=%b | o1_r=%b o2_r=%b f_r=%b",
                  $time, a, b, c, d, o1, o2, f, o1_real, o2_real, f_real);
    end

    // ── Stimulus ─────────────────────────────────────────────────────────────
    initial begin

        // =====================================================================
        // SLIDE 12  –  Switching Activity on o2
        // Circuit: a&b -> o1;  o1&c -> o2;  o2&d -> f
        // Initial: a=1,b=1,c=0 => o1=1, o2=0, f=0  (o2 is our glitch node)
        // Each T+1 vector: a and/or b drop while c rises — o1 momentarily
        //   stays 1 (gate delay) while c is already 1, so o2 spikes to 1
        // =====================================================================
        $display("=== SLIDE 12 : Switching Activity on o2 ===");

        // T  – stable initial state
        a=1; b=1; c=0; d=0;
        #10;

        // Glitch 1: a=0, b=0, c=1  (both AND inputs drop, c rises)
        $display("--- Slide 12 Glitch 1 ---");
        a=0; b=0; c=1;
        #10;

        // Return to initial
        a=1; b=1; c=0; d=0;
        #10;

        // Glitch 2: a=0, b=1, c=1
        $display("--- Slide 12 Glitch 2 ---");
        a=0; b=1; c=1;
        #10;

        // Return to initial
        a=1; b=1; c=0; d=0;
        #10;

        // Glitch 3: a=1, b=0, c=1
        $display("--- Slide 12 Glitch 3 ---");
        a=1; b=0; c=1;
        #10;

        // Return to initial
        a=1; b=1; c=0; d=0;
        #10;

        // =====================================================================
        // SLIDE 13  –  Switching Activity on f
        // Initial: a=1,b=1,c=1,d=0 => o1=1, o2=1, f=0  (f is our glitch node)
        // Each T+1 vector: d rises to 1 while one or more of a,b,c drop.
        //   o2 is still 1 when d first arrives => f spikes to 1 (glitch)
        //   then o2 propagates the new AND result and f settles to 0.
        // =====================================================================
        $display("=== SLIDE 13 : Switching Activity on f ===");

        // T  – stable initial state
        a=1; b=1; c=1; d=0;
        #10;

        // Glitch 1
        $display("--- Slide 13 Glitch 1 ---");
        a=0; b=0; c=0; d=1;
        #10;

        a=1; b=1; c=1; d=0;
        #10;

        // Glitch 2
        $display("--- Slide 13 Glitch 2 ---");
        a=1; b=0; c=0; d=1;
        #10;

        a=1; b=1; c=1; d=0;
        #10;

        // Glitch 3
        $display("--- Slide 13 Glitch 3 ---");
        a=0; b=1; c=0; d=1;
        #10;

        a=1; b=1; c=1; d=0;
        #10;

        // Glitch 4
        $display("--- Slide 13 Glitch 4 ---");
        a=1; b=1; c=0; d=1;
        #10;

        a=1; b=1; c=1; d=0;
        #10;

        // Glitch 5
        $display("--- Slide 13 Glitch 5 ---");
        a=0; b=0; c=1; d=1;
        #10;

        a=1; b=1; c=1; d=0;
        #10;

        // Glitch 6
        $display("--- Slide 13 Glitch 6 ---");
        a=1; b=0; c=1; d=1;
        #10;

        a=1; b=1; c=1; d=0;
        #10;

        // Glitch 7
        $display("--- Slide 13 Glitch 7 ---");
        a=0; b=1; c=1; d=1;
        #10;

        a=1; b=1; c=1; d=0;
        #10;

        $display("=== Simulation complete. $stop called. ===");
        $stop;
    end

endmodule
