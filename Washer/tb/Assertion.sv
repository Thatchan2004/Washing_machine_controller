// Assertions for the washer FSM.
// Bound into the DUT from Top.sv (see "bind washer Assertion ..."), so the
// internal state register (cst) is visible through the "state" port.
module Assertion (
    input logic       clk,
    input logic       rst,
    input logic       coin,
    input logic       wet,
    input logic       soap,

    input logic [2:0] state,

    input logic       timerbegin,
    input logic       fillwater,
    input logic       refill,
    input logic       drain,

    input logic [4:0] timercounter
);

    localparam logic [2:0] IDLE    = 3'b000,
                           COUNTER = 3'b001,
                           WASH    = 3'b010,
                           RINSE   = 3'b011,
                           DRY     = 3'b100;

    // ---------------------------------------------------------------
    // Reset
    // The reset is synchronous and the outputs are registered/decoded
    // from cst, so they are only guaranteed to be cleared on the clock
    // AFTER reset was sampled high (hence |=> and not |->).
    // ---------------------------------------------------------------
    a_reset_state_outputs: assert property (
        @(posedge clk)
        rst |=> (state == IDLE &&
                 !timerbegin && !fillwater && !refill && !drain &&
                 timercounter == 5'd0)
    ) else $error("ASSERTION FAILED: state/outputs/timer not cleared after reset");

    // ---------------------------------------------------------------
    // Output decode: at most one output on, and each one matches its state
    // ---------------------------------------------------------------
    a_outputs_onehot0: assert property (
        @(posedge clk) disable iff (rst)
        $onehot0({timerbegin, fillwater, refill, drain})
    ) else $error("ASSERTION FAILED: more than one output active");

    a_output_decode: assert property (
        @(posedge clk) disable iff (rst)
        (timerbegin == (state == COUNTER)) &&
        (fillwater  == (state == WASH))    &&
        (refill     == (state == RINSE))   &&
        (drain      == (state == DRY))
    ) else $error("ASSERTION FAILED: outputs do not match state");

    // ---------------------------------------------------------------
    // State transitions
    // ---------------------------------------------------------------
    a_idle_to_counter: assert property (
        @(posedge clk) disable iff (rst)
        (state == IDLE && coin) |=> (state == COUNTER && timerbegin)
    ) else $error("ASSERTION FAILED: IDLE + coin should go to COUNTER");

    a_idle_hold: assert property (
        @(posedge clk) disable iff (rst)
        (state == IDLE && !coin) |=> (state == IDLE)
    ) else $error("ASSERTION FAILED: IDLE without coin should stay in IDLE");

    a_counter_to_wash: assert property (
        @(posedge clk) disable iff (rst)
        (state == COUNTER) |=> (state == WASH && fillwater)
    ) else $error("ASSERTION FAILED: COUNTER should go to WASH");

    a_wash_to_rinse: assert property (
        @(posedge clk) disable iff (rst)
        (state == WASH && timercounter > 5'd30) |=> (state == RINSE && refill)
    ) else $error("ASSERTION FAILED: WASH with timer>30 should go to RINSE");

    a_wash_hold: assert property (
        @(posedge clk) disable iff (rst)
        (state == WASH && !(timercounter > 5'd30)) |=> (state == WASH)
    ) else $error("ASSERTION FAILED: WASH left before timer>30");

    a_rinse_to_dry: assert property (
        @(posedge clk) disable iff (rst)
        (state == RINSE && !soap) |=> (state == DRY && drain)
    ) else $error("ASSERTION FAILED: RINSE with soap==0 should go to DRY");

    a_rinse_hold: assert property (
        @(posedge clk) disable iff (rst)
        (state == RINSE && soap) |=> (state == RINSE)
    ) else $error("ASSERTION FAILED: RINSE left while soap still present");

    a_dry_to_idle: assert property (
        @(posedge clk) disable iff (rst)
        (state == DRY && !wet) |=> (state == IDLE)
    ) else $error("ASSERTION FAILED: DRY with wet==0 should go to IDLE");

    a_dry_hold: assert property (
        @(posedge clk) disable iff (rst)
        (state == DRY && wet) |=> (state == DRY)
    ) else $error("ASSERTION FAILED: DRY left while still wet");

    // ---------------------------------------------------------------
    // Timer
    // ---------------------------------------------------------------
    a_timer_count: assert property (
        @(posedge clk) disable iff (rst)
        coin |=> (timercounter == 5'($past(timercounter) + 5'd1))
    ) else $error("ASSERTION FAILED: timer did not increment while coin high");

    a_timer_clear: assert property (
        @(posedge clk) disable iff (rst)
        !coin |=> (timercounter == 5'd0)
    ) else $error("ASSERTION FAILED: timer not cleared when coin low");

endmodule
