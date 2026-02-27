/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : X-2025.06-SP4
// Date      : Thu Feb 26 21:43:18 2026
/////////////////////////////////////////////////////////////


module p3 ( clk, rst_n, start_btn, pause_btn, cancel_btn, mode_sel, 
        opt_extra_rinse, opt_high_spin, door_closed, water_ok, temp_ok, 
        level_full, level_empty, imbalance, timer_done, valve_inlet, pump_out, 
        motor_agitate, motor_spin, heater_on, door_lock, alarm, done_led, 
        state_id );
  input [1:0] mode_sel;
  output [5:0] state_id;
  input clk, rst_n, start_btn, pause_btn, cancel_btn, opt_extra_rinse,
         opt_high_spin, door_closed, water_ok, temp_ok, level_full,
         level_empty, imbalance, timer_done;
  output valve_inlet, pump_out, motor_agitate, motor_spin, heater_on,
         door_lock, alarm, done_led;
  wire   extra_rinse_q, high_spin_q, N385, N432, N443, N454, N470, n183, n185,
         n187, n189, n196, n197, n198, n199, n200, n202, n203, n204, n205,
         n206, n207, n208, n209, n210, n211, n212, n213, n214, n215, n216,
         n217, n218, n219, n220, n221, n222, n223, n224, n225, n226, n227,
         n228, n229, n230, n231, n232, n233, n234, n235, n236, n237, n238,
         n239, n240, n241, n242, n243, n244, n245, n246, n247, n248, n249,
         n250, n251, n252, n253, n254, n255, n256, n257, n258, n259, n260,
         n261, n262, n263, n264, n265, n266, n267, n268, n269, n270, n271,
         n272, n273, n274, n275, n276, n277, n278, n279, n280, n281, n282,
         n283, n284, n285, n286, n287, n288, n289, n290, n291, n292, n293,
         n294, n295, n296, n297, n298, n299, n300, n301, n302, n303, n304,
         n305, n306, n307, n308, n309, n310, n311, n312, n313, n314, n315,
         n316, n317, n318, n319, n320, n321, n322, n323, n324, n325, n326,
         n327, n328, n329, n330, n331, n332, n333, n334, n335, n336, n337,
         n338, n339, n340, n341, n342, n343, n344, n345, n346, n347, n348,
         n349, n350, n351, n352, n353, n354, n355, n356, n357, n358, n359,
         n360, n361, n362, n363, n364, n365, n366, n367, n368, n369, n370,
         n371, n372, n373, n374, n375, n376, n377, n378;
  wire   [1:0] mode_q;
  assign state_id[5] = 1'b0;
  assign valve_inlet = N385;
  assign motor_agitate = N432;
  assign motor_spin = N443;
  assign heater_on = N454;
  assign alarm = N470;

  DFFSR \state_reg[0]  ( .D(n200), .CLK(clk), .R(rst_n), .S(1'b1), .Q(
        state_id[0]) );
  DFFSR \state_reg[1]  ( .D(n199), .CLK(clk), .R(rst_n), .S(1'b1), .Q(
        state_id[1]) );
  DFFSR \state_reg[4]  ( .D(n196), .CLK(clk), .R(rst_n), .S(1'b1), .Q(
        state_id[4]) );
  DFFSR \state_reg[3]  ( .D(n197), .CLK(clk), .R(rst_n), .S(1'b1), .Q(
        state_id[3]) );
  DFFSR \state_reg[2]  ( .D(n198), .CLK(clk), .R(rst_n), .S(1'b1), .Q(
        state_id[2]) );
  DFFSR \mode_q_reg[1]  ( .D(n189), .CLK(clk), .R(rst_n), .S(1'b1), .Q(
        mode_q[1]) );
  DFFSR extra_rinse_q_reg ( .D(n187), .CLK(clk), .R(rst_n), .S(1'b1), .Q(
        extra_rinse_q) );
  DFFSR high_spin_q_reg ( .D(n185), .CLK(clk), .R(rst_n), .S(1'b1), .Q(
        high_spin_q) );
  DFFSR \mode_q_reg[0]  ( .D(n183), .CLK(clk), .R(rst_n), .S(1'b1), .Q(
        mode_q[0]) );
  MUX2X1 U211 ( .B(n202), .A(n203), .S(n204), .Y(n200) );
  NOR2X1 U212 ( .A(n205), .B(n206), .Y(n202) );
  NAND3X1 U213 ( .A(n207), .B(n208), .C(n209), .Y(n206) );
  NOR2X1 U214 ( .A(n210), .B(n211), .Y(n209) );
  OAI21X1 U215 ( .A(pause_btn), .B(n212), .C(n213), .Y(n211) );
  INVX1 U216 ( .A(n214), .Y(n208) );
  MUX2X1 U217 ( .B(done_led), .A(n215), .S(cancel_btn), .Y(n207) );
  NAND3X1 U218 ( .A(n216), .B(n217), .C(n218), .Y(n215) );
  INVX1 U219 ( .A(n219), .Y(n216) );
  OR2X1 U220 ( .A(n220), .B(n221), .Y(n205) );
  OAI21X1 U221 ( .A(n222), .B(n223), .C(n224), .Y(n221) );
  AOI22X1 U222 ( .A(door_closed), .B(n225), .C(n226), .D(n227), .Y(n224) );
  INVX1 U223 ( .A(n228), .Y(n226) );
  OAI21X1 U224 ( .A(water_ok), .B(n229), .C(n230), .Y(n225) );
  NAND3X1 U225 ( .A(n231), .B(n232), .C(n233), .Y(n220) );
  MUX2X1 U226 ( .B(n234), .A(n235), .S(n204), .Y(n199) );
  NOR2X1 U227 ( .A(n236), .B(n237), .Y(n234) );
  OR2X1 U228 ( .A(n238), .B(n239), .Y(n237) );
  OAI21X1 U229 ( .A(n212), .B(n240), .C(n241), .Y(n239) );
  OAI21X1 U230 ( .A(n242), .B(n243), .C(n244), .Y(n241) );
  NAND2X1 U231 ( .A(n213), .B(n245), .Y(n243) );
  INVX1 U232 ( .A(n246), .Y(n213) );
  OAI21X1 U233 ( .A(n247), .B(n248), .C(n249), .Y(n246) );
  NAND2X1 U234 ( .A(imbalance), .B(n250), .Y(n249) );
  NAND3X1 U235 ( .A(n251), .B(n252), .C(n253), .Y(n242) );
  OAI21X1 U236 ( .A(door_closed), .B(n230), .C(n254), .Y(n236) );
  AND2X1 U237 ( .A(n255), .B(n233), .Y(n254) );
  MUX2X1 U238 ( .B(n256), .A(n257), .S(n204), .Y(n198) );
  NOR2X1 U239 ( .A(n258), .B(n259), .Y(n256) );
  NAND2X1 U240 ( .A(n260), .B(n261), .Y(n259) );
  INVX1 U241 ( .A(n238), .Y(n261) );
  OAI21X1 U242 ( .A(n228), .B(n227), .C(n262), .Y(n238) );
  AND2X1 U243 ( .A(n263), .B(n264), .Y(n262) );
  OAI21X1 U244 ( .A(n265), .B(n266), .C(n267), .Y(n264) );
  INVX1 U245 ( .A(water_ok), .Y(n266) );
  OAI21X1 U246 ( .A(n268), .B(n269), .C(n244), .Y(n263) );
  OAI21X1 U247 ( .A(door_closed), .B(n251), .C(n270), .Y(n269) );
  NAND2X1 U248 ( .A(n271), .B(n272), .Y(n268) );
  OAI21X1 U249 ( .A(mode_q[0]), .B(n273), .C(n274), .Y(n227) );
  NOR2X1 U250 ( .A(extra_rinse_q), .B(cancel_btn), .Y(n274) );
  AOI22X1 U251 ( .A(n275), .B(n244), .C(n276), .D(n277), .Y(n260) );
  NAND3X1 U252 ( .A(n278), .B(n231), .C(n279), .Y(n275) );
  NOR2X1 U253 ( .A(n250), .B(n280), .Y(n279) );
  INVX1 U254 ( .A(n281), .Y(n250) );
  INVX1 U255 ( .A(n282), .Y(n278) );
  OAI21X1 U256 ( .A(n240), .B(n283), .C(n284), .Y(n258) );
  NOR2X1 U257 ( .A(n285), .B(n286), .Y(n284) );
  INVX1 U258 ( .A(n230), .Y(n286) );
  NAND2X1 U259 ( .A(n287), .B(n288), .Y(n230) );
  MUX2X1 U260 ( .B(n289), .A(n290), .S(n204), .Y(n197) );
  NOR2X1 U261 ( .A(n291), .B(n292), .Y(n289) );
  NAND3X1 U262 ( .A(n293), .B(n294), .C(n295), .Y(n292) );
  AOI21X1 U263 ( .A(door_closed), .B(n296), .C(n219), .Y(n295) );
  NAND3X1 U264 ( .A(n283), .B(n297), .C(n270), .Y(n219) );
  INVX1 U265 ( .A(N454), .Y(n297) );
  INVX1 U266 ( .A(n210), .Y(n294) );
  OAI21X1 U267 ( .A(n298), .B(n299), .C(n300), .Y(n210) );
  AOI21X1 U268 ( .A(n301), .B(n302), .C(n303), .Y(n300) );
  INVX1 U269 ( .A(n272), .Y(n303) );
  NOR2X1 U270 ( .A(n304), .B(n248), .Y(n301) );
  OR2X1 U271 ( .A(n305), .B(n306), .Y(n291) );
  OAI22X1 U272 ( .A(high_spin_q), .B(n232), .C(n217), .D(n307), .Y(n306) );
  INVX1 U273 ( .A(n240), .Y(n307) );
  OAI21X1 U274 ( .A(n308), .B(n244), .C(n309), .Y(n305) );
  MUX2X1 U275 ( .B(n310), .A(n311), .S(n204), .Y(n196) );
  OAI21X1 U276 ( .A(n223), .B(n312), .C(n313), .Y(n204) );
  OAI22X1 U277 ( .A(n314), .B(n315), .C(n285), .D(n244), .Y(n313) );
  OAI21X1 U278 ( .A(level_empty), .B(n316), .C(n317), .Y(n315) );
  AOI21X1 U279 ( .A(n288), .B(n318), .C(n319), .Y(n317) );
  NOR2X1 U280 ( .A(timer_done), .B(n320), .Y(n319) );
  NOR2X1 U281 ( .A(n282), .B(n321), .Y(n320) );
  OAI21X1 U282 ( .A(n247), .B(n248), .C(n322), .Y(n321) );
  OAI21X1 U283 ( .A(n323), .B(n324), .C(n325), .Y(n322) );
  INVX1 U284 ( .A(temp_ok), .Y(n248) );
  NAND3X1 U285 ( .A(n326), .B(n232), .C(n327), .Y(n282) );
  AOI22X1 U286 ( .A(n328), .B(n329), .C(n287), .D(n330), .Y(n327) );
  NOR2X1 U287 ( .A(n331), .B(n332), .Y(n326) );
  INVX1 U288 ( .A(n223), .Y(n288) );
  INVX1 U289 ( .A(pump_out), .Y(n316) );
  NAND3X1 U290 ( .A(n228), .B(n270), .C(n333), .Y(pump_out) );
  NOR2X1 U291 ( .A(n334), .B(n335), .Y(n333) );
  OR2X1 U292 ( .A(n280), .B(n285), .Y(n335) );
  NAND2X1 U293 ( .A(n328), .B(n336), .Y(n270) );
  NAND2X1 U294 ( .A(n337), .B(n338), .Y(n314) );
  OAI21X1 U295 ( .A(n339), .B(n340), .C(n341), .Y(n338) );
  NAND2X1 U296 ( .A(n252), .B(n342), .Y(n340) );
  NAND3X1 U297 ( .A(n336), .B(n311), .C(n277), .Y(n252) );
  AOI22X1 U298 ( .A(n287), .B(n343), .C(n344), .D(n345), .Y(n337) );
  INVX1 U299 ( .A(level_full), .Y(n345) );
  OAI21X1 U300 ( .A(n251), .B(n265), .C(n346), .Y(n344) );
  INVX1 U301 ( .A(door_closed), .Y(n265) );
  OAI21X1 U302 ( .A(state_id[4]), .B(n347), .C(n348), .Y(n343) );
  NAND2X1 U303 ( .A(n277), .B(n341), .Y(n312) );
  INVX1 U304 ( .A(start_btn), .Y(n341) );
  NOR2X1 U305 ( .A(n349), .B(n350), .Y(n310) );
  NAND3X1 U306 ( .A(n293), .B(n217), .C(n308), .Y(n350) );
  INVX1 U307 ( .A(n351), .Y(n308) );
  NAND3X1 U308 ( .A(n232), .B(n228), .C(n218), .Y(n351) );
  INVX1 U309 ( .A(n352), .Y(n218) );
  NAND3X1 U310 ( .A(n271), .B(n281), .C(n245), .Y(n352) );
  AOI21X1 U311 ( .A(n330), .B(n277), .C(n331), .Y(n245) );
  NAND3X1 U312 ( .A(n353), .B(state_id[4]), .C(n287), .Y(n281) );
  INVX1 U313 ( .A(n334), .Y(n271) );
  NOR2X1 U314 ( .A(n354), .B(n222), .Y(n334) );
  NAND2X1 U315 ( .A(n277), .B(n355), .Y(n228) );
  NAND2X1 U316 ( .A(n287), .B(n355), .Y(n232) );
  INVX1 U317 ( .A(n324), .Y(n217) );
  OAI21X1 U318 ( .A(n299), .B(n356), .C(n212), .Y(n324) );
  NAND2X1 U319 ( .A(state_id[1]), .B(state_id[0]), .Y(n356) );
  AOI21X1 U320 ( .A(cancel_btn), .B(n339), .C(n214), .Y(n293) );
  NAND3X1 U321 ( .A(n357), .B(n253), .C(n358), .Y(n214) );
  AOI22X1 U322 ( .A(n287), .B(n330), .C(n296), .D(cancel_btn), .Y(n358) );
  INVX1 U323 ( .A(n251), .Y(n296) );
  NOR2X1 U324 ( .A(n285), .B(n280), .Y(n357) );
  INVX1 U325 ( .A(n359), .Y(n280) );
  NAND3X1 U326 ( .A(n355), .B(state_id[3]), .C(state_id[2]), .Y(n359) );
  NOR2X1 U327 ( .A(n360), .B(n361), .Y(n285) );
  INVX1 U328 ( .A(n231), .Y(n339) );
  NAND2X1 U329 ( .A(n355), .B(n318), .Y(n231) );
  NOR2X1 U330 ( .A(n298), .B(n311), .Y(n355) );
  NAND3X1 U331 ( .A(n255), .B(n362), .C(n363), .Y(n349) );
  AOI21X1 U332 ( .A(n323), .B(n240), .C(n364), .Y(n363) );
  AOI21X1 U333 ( .A(n299), .B(n247), .C(n244), .Y(n364) );
  NAND2X1 U334 ( .A(n325), .B(n244), .Y(n240) );
  INVX1 U335 ( .A(cancel_btn), .Y(n244) );
  INVX1 U336 ( .A(pause_btn), .Y(n325) );
  INVX1 U337 ( .A(n283), .Y(n323) );
  NAND2X1 U338 ( .A(n276), .B(n318), .Y(n283) );
  INVX1 U339 ( .A(n348), .Y(n276) );
  NAND2X1 U340 ( .A(n304), .B(n302), .Y(n255) );
  INVX1 U341 ( .A(n309), .Y(n302) );
  NAND3X1 U342 ( .A(n267), .B(door_closed), .C(water_ok), .Y(n309) );
  INVX1 U343 ( .A(n229), .Y(n267) );
  NAND3X1 U344 ( .A(n336), .B(n311), .C(n287), .Y(n229) );
  AND2X1 U345 ( .A(mode_q[1]), .B(mode_q[0]), .Y(n304) );
  MUX2X1 U346 ( .B(n365), .A(n273), .S(n233), .Y(n189) );
  INVX1 U347 ( .A(mode_q[1]), .Y(n273) );
  INVX1 U348 ( .A(mode_sel[1]), .Y(n365) );
  INVX1 U349 ( .A(n366), .Y(n187) );
  MUX2X1 U350 ( .B(opt_extra_rinse), .A(extra_rinse_q), .S(n233), .Y(n366) );
  INVX1 U351 ( .A(n367), .Y(n185) );
  MUX2X1 U352 ( .B(opt_high_spin), .A(high_spin_q), .S(n233), .Y(n367) );
  INVX1 U353 ( .A(n368), .Y(n183) );
  MUX2X1 U354 ( .B(mode_sel[0]), .A(mode_q[0]), .S(n233), .Y(n368) );
  NAND3X1 U355 ( .A(n277), .B(n311), .C(n353), .Y(n233) );
  NAND2X1 U356 ( .A(n369), .B(n370), .Y(door_lock) );
  MUX2X1 U357 ( .B(n371), .A(n290), .S(state_id[4]), .Y(n370) );
  MUX2X1 U358 ( .B(n257), .A(n290), .S(state_id[1]), .Y(n371) );
  MUX2X1 U359 ( .B(n318), .A(state_id[2]), .S(n329), .Y(n369) );
  INVX1 U360 ( .A(n342), .Y(done_led) );
  NAND3X1 U361 ( .A(n330), .B(state_id[3]), .C(state_id[2]), .Y(n342) );
  INVX1 U362 ( .A(n360), .Y(n330) );
  OAI21X1 U363 ( .A(n361), .B(n223), .C(n372), .Y(N470) );
  NAND3X1 U364 ( .A(state_id[1]), .B(n311), .C(n287), .Y(n372) );
  INVX1 U365 ( .A(n373), .Y(n287) );
  NAND2X1 U366 ( .A(n329), .B(n311), .Y(n223) );
  INVX1 U367 ( .A(n298), .Y(n329) );
  NAND2X1 U368 ( .A(n235), .B(n203), .Y(n298) );
  NAND2X1 U369 ( .A(n362), .B(n247), .Y(N454) );
  NAND3X1 U370 ( .A(n318), .B(n311), .C(n353), .Y(n247) );
  INVX1 U371 ( .A(n332), .Y(n362) );
  NOR2X1 U372 ( .A(n354), .B(n361), .Y(n332) );
  NOR2X1 U373 ( .A(n373), .B(n374), .Y(N443) );
  NAND2X1 U374 ( .A(state_id[4]), .B(n235), .Y(n374) );
  INVX1 U375 ( .A(state_id[1]), .Y(n235) );
  OAI21X1 U376 ( .A(n290), .B(n348), .C(n375), .Y(N432) );
  NOR2X1 U377 ( .A(n331), .B(n376), .Y(n375) );
  INVX1 U378 ( .A(n212), .Y(n376) );
  NAND3X1 U379 ( .A(n277), .B(state_id[4]), .C(n353), .Y(n212) );
  INVX1 U380 ( .A(n222), .Y(n277) );
  NOR2X1 U381 ( .A(n373), .B(n354), .Y(n331) );
  NAND3X1 U382 ( .A(state_id[4]), .B(state_id[0]), .C(state_id[1]), .Y(n354)
         );
  NAND2X1 U383 ( .A(state_id[2]), .B(n290), .Y(n373) );
  NAND3X1 U384 ( .A(state_id[0]), .B(n311), .C(state_id[1]), .Y(n348) );
  NAND2X1 U385 ( .A(n346), .B(n251), .Y(N385) );
  NAND3X1 U386 ( .A(n336), .B(n311), .C(n318), .Y(n251) );
  INVX1 U387 ( .A(n377), .Y(n346) );
  OAI21X1 U388 ( .A(n360), .B(n222), .C(n378), .Y(n377) );
  AND2X1 U389 ( .A(n272), .B(n253), .Y(n378) );
  NAND3X1 U390 ( .A(n318), .B(state_id[4]), .C(n353), .Y(n253) );
  INVX1 U391 ( .A(n361), .Y(n318) );
  NAND2X1 U392 ( .A(state_id[3]), .B(n257), .Y(n361) );
  NAND2X1 U393 ( .A(n353), .B(n328), .Y(n272) );
  INVX1 U394 ( .A(n299), .Y(n328) );
  NAND3X1 U395 ( .A(state_id[3]), .B(n311), .C(state_id[2]), .Y(n299) );
  INVX1 U396 ( .A(state_id[4]), .Y(n311) );
  INVX1 U397 ( .A(n347), .Y(n353) );
  NAND2X1 U398 ( .A(state_id[1]), .B(n203), .Y(n347) );
  NAND2X1 U399 ( .A(n290), .B(n257), .Y(n222) );
  INVX1 U400 ( .A(state_id[2]), .Y(n257) );
  INVX1 U401 ( .A(state_id[3]), .Y(n290) );
  NAND2X1 U402 ( .A(state_id[4]), .B(n336), .Y(n360) );
  NOR2X1 U403 ( .A(n203), .B(state_id[1]), .Y(n336) );
  INVX1 U404 ( .A(state_id[0]), .Y(n203) );
endmodule

