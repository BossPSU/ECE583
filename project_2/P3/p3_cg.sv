//laundry machine fsm with 25 unique moore states
module p3_cg (
    input  logic        clk,
    input  logic        rst_n,

    // user inputs
    input  logic        start_btn,
    input  logic        pause_btn,
    input  logic        cancel_btn,
    input  logic [1:0]  mode_sel,        // 0=Normal,1=Heavy,2=Delicate,3=SelfClean
    input  logic        opt_extra_rinse,
    input  logic        opt_high_spin,

    // sensors
    input  logic        door_closed,
    input  logic        water_ok,
    input  logic        temp_ok,
    input  logic        level_full,
    input  logic        level_empty,
    input  logic        imbalance,

    // timing (phase timer done)
    input  logic        timer_done,

    // Moore outputs (depend only on state)
    output logic        valve_inlet,
    output logic        pump_out,
    output logic        motor_agitate,
    output logic        motor_spin,
    output logic        heater_on,
    output logic        door_lock,
    output logic        alarm,
    output logic        done_led,

    output logic [5:0]  state_id
);

    typedef enum logic [5:0] {
        S_IDLE               = 6'd0,
        S_MENU               = 6'd1,
        S_LOAD_OPTIONS       = 6'd2,
        S_VALIDATE_OPTIONS   = 6'd3,
        S_LOCK_DOOR          = 6'd4,
        S_PRECHECK_SENSORS   = 6'd5,
        S_FAULT_DOOR         = 6'd6,
        S_FAULT_WATER        = 6'd7,
        S_FAULT_TEMP         = 6'd8,

        S_FILL_WASH          = 6'd9,
        S_HEAT_WASH          = 6'd10,
        S_AGITATE_WASH       = 6'd11,
        S_SOAK               = 6'd12,
        S_DRAIN_WASH         = 6'd13,

        S_FILL_RINSE1        = 6'd14,
        S_AGITATE_RINSE1     = 6'd15,
        S_DRAIN_RINSE1       = 6'd16,

        S_FILL_RINSE2        = 6'd17,
        S_AGITATE_RINSE2     = 6'd18,
        S_DRAIN_RINSE2       = 6'd19,

        S_SPIN_LOW           = 6'd20,
        S_SPIN_HIGH          = 6'd21,
        S_BALANCE_CHECK      = 6'd22,
        S_UNBALANCE_RECOVER  = 6'd23,

        S_PAUSED             = 6'd24,
        S_CANCEL_DRAIN       = 6'd25,

        S_SELF_CLEAN_FILL    = 6'd26,
        S_SELF_CLEAN_HEAT    = 6'd27,
        S_SELF_CLEAN_FLUSH   = 6'd28,

        S_DONE               = 6'd29
    } state_t;

    state_t state, next_state;

    // latched options (so behavior is stable during run)
    logic [1:0] mode_q;
    logic       extra_rinse_q;
    logic       high_spin_q;

    // latch options in LOAD_OPTIONS
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mode_q        <= 2'd0;
            extra_rinse_q <= 1'b0;
            high_spin_q   <= 1'b0;
        end else if (state == S_LOAD_OPTIONS) begin
            mode_q        <= mode_sel;
            extra_rinse_q <= opt_extra_rinse;
            high_spin_q   <= opt_high_spin;
        end
    end

    // state register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S_IDLE;
        else        state <= next_state;
    end

    // next-state logic (inputs allowed here; still Moore outputs)
    always_comb begin
        next_state = state;

        unique case (state)
            S_IDLE: begin
                if (start_btn) next_state = S_MENU;
            end

            S_MENU: begin
                // entering menu; pressing start again locks in selection
                if (cancel_btn) next_state = S_IDLE;
                else if (start_btn) next_state = S_LOAD_OPTIONS;
            end

            S_LOAD_OPTIONS: begin
                next_state = S_VALIDATE_OPTIONS;
            end

            S_VALIDATE_OPTIONS: begin
                // could add more constraints if desired
                next_state = S_LOCK_DOOR;
            end

            S_LOCK_DOOR: begin
                if (!door_closed) next_state = S_FAULT_DOOR;
                else next_state = S_PRECHECK_SENSORS;
            end

            S_PRECHECK_SENSORS: begin
                if (!door_closed)      next_state = S_FAULT_DOOR;
                else if (!water_ok)    next_state = S_FAULT_WATER;
                else if (!temp_ok && mode_q != 2'd3) next_state = S_FAULT_TEMP; // ignore temp in self-clean if you want
                else begin
                    if (mode_q == 2'd3) next_state = S_SELF_CLEAN_FILL;
                    else next_state = S_FILL_WASH;
                end
            end

            // faults: alarm until cancel
            S_FAULT_DOOR:  if (cancel_btn) next_state = S_IDLE;
            S_FAULT_WATER: if (cancel_btn) next_state = S_IDLE;
            S_FAULT_TEMP:  if (cancel_btn) next_state = S_IDLE;

            // wash path
            S_FILL_WASH: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (!door_closed) next_state = S_FAULT_DOOR;
                else if (level_full) next_state = S_HEAT_WASH;
            end

            S_HEAT_WASH: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (!temp_ok) next_state = S_FAULT_TEMP;
                else if (timer_done) next_state = S_AGITATE_WASH;
            end

            S_AGITATE_WASH: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (pause_btn) next_state = S_PAUSED;
                else if (timer_done) next_state = S_SOAK;
            end

            S_SOAK: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (timer_done) next_state = S_DRAIN_WASH;
            end

            S_DRAIN_WASH: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (level_empty) next_state = S_FILL_RINSE1;
            end

            // rinse 1
            S_FILL_RINSE1: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (level_full) next_state = S_AGITATE_RINSE1;
            end

            S_AGITATE_RINSE1: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (pause_btn) next_state = S_PAUSED;
                else if (timer_done) next_state = S_DRAIN_RINSE1;
            end

            S_DRAIN_RINSE1: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (level_empty) begin
                    if (extra_rinse_q || mode_q == 2'd2) next_state = S_FILL_RINSE2; // delicate also gets rinse2
                    else next_state = S_BALANCE_CHECK;
                end
            end

            // rinse 2 (optional)
            S_FILL_RINSE2: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (level_full) next_state = S_AGITATE_RINSE2;
            end

            S_AGITATE_RINSE2: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (pause_btn) next_state = S_PAUSED;
                else if (timer_done) next_state = S_DRAIN_RINSE2;
            end

            S_DRAIN_RINSE2: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (level_empty) next_state = S_BALANCE_CHECK;
            end

            // spin + balance logic
            S_BALANCE_CHECK: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (imbalance) next_state = S_UNBALANCE_RECOVER;
                else next_state = S_SPIN_LOW;
            end

            S_UNBALANCE_RECOVER: begin
                // try re-agitate briefly to redistribute
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (timer_done) next_state = S_BALANCE_CHECK;
            end

            S_SPIN_LOW: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (timer_done) begin
                    if (high_spin_q) next_state = S_SPIN_HIGH;
                    else next_state = S_DONE;
                end
            end

            S_SPIN_HIGH: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (timer_done) next_state = S_DONE;
            end

            // pause: resume with start, cancel drains
            S_PAUSED: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (start_btn) next_state = S_PRECHECK_SENSORS; // safe resume entry
            end

            // cancel: always drain then done (or idle)
            S_CANCEL_DRAIN: begin
                if (level_empty) next_state = S_DONE;
            end

            // self-clean cycle
            S_SELF_CLEAN_FILL: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (level_full) next_state = S_SELF_CLEAN_HEAT;
            end

            S_SELF_CLEAN_HEAT: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (timer_done) next_state = S_SELF_CLEAN_FLUSH;
            end

            S_SELF_CLEAN_FLUSH: begin
                if (cancel_btn) next_state = S_CANCEL_DRAIN;
                else if (level_empty) next_state = S_DONE;
            end

            S_DONE: begin
                if (cancel_btn) next_state = S_IDLE;
                else if (start_btn) next_state = S_MENU;
            end

            default: next_state = S_IDLE;
        endcase
    end

    // Moore output logic (ONLY depends on state)
    always_comb begin
        // defaults
        valve_inlet   = 1'b0;
        pump_out      = 1'b0;
        motor_agitate = 1'b0;
        motor_spin    = 1'b0;
        heater_on     = 1'b0;
        door_lock     = 1'b0;
        alarm         = 1'b0;
        done_led      = 1'b0;

        unique case (state)
            S_IDLE, S_MENU, S_LOAD_OPTIONS, S_VALIDATE_OPTIONS: begin
                door_lock = 1'b0;
            end

            S_LOCK_DOOR, S_PRECHECK_SENSORS,
            S_FILL_WASH, S_HEAT_WASH, S_AGITATE_WASH, S_SOAK, S_DRAIN_WASH,
            S_FILL_RINSE1, S_AGITATE_RINSE1, S_DRAIN_RINSE1,
            S_FILL_RINSE2, S_AGITATE_RINSE2, S_DRAIN_RINSE2,
            S_SPIN_LOW, S_SPIN_HIGH, S_BALANCE_CHECK, S_UNBALANCE_RECOVER,
            S_CANCEL_DRAIN,
            S_SELF_CLEAN_FILL, S_SELF_CLEAN_HEAT, S_SELF_CLEAN_FLUSH: begin
                door_lock = 1'b1;
            end

            default: door_lock = 1'b0;
        endcase

        unique case (state)
            S_FILL_WASH, S_FILL_RINSE1, S_FILL_RINSE2, S_SELF_CLEAN_FILL: begin
                valve_inlet = 1'b1;
            end
            default: ;
        endcase

        unique case (state)
            S_DRAIN_WASH, S_DRAIN_RINSE1, S_DRAIN_RINSE2, S_CANCEL_DRAIN, S_SELF_CLEAN_FLUSH: begin
                pump_out = 1'b1;
            end
            default: ;
        endcase

        unique case (state)
            S_AGITATE_WASH, S_AGITATE_RINSE1, S_AGITATE_RINSE2, S_UNBALANCE_RECOVER: begin
                motor_agitate = 1'b1;
            end
            default: ;
        endcase

        unique case (state)
            S_SPIN_LOW, S_SPIN_HIGH: begin
                motor_spin = 1'b1;
            end
            default: ;
        endcase

        unique case (state)
            S_HEAT_WASH, S_SELF_CLEAN_HEAT: begin
                heater_on = 1'b1;
            end
            default: ;
        endcase

        unique case (state)
            S_FAULT_DOOR, S_FAULT_WATER, S_FAULT_TEMP: begin
                alarm = 1'b1;
            end
            default: ;
        endcase

        if (state == S_DONE) done_led = 1'b1;

        state_id = state;
    end

endmodule
