module Top;

    import uvm_pkg::*;
    import washer_pkg::*;

    logic clk;

    washer_if vif(clk);

    washer dut (
        .clk           (clk),
        .rst           (vif.rst),
        .coin          (vif.coin),
        .wet           (vif.wet),
        .soap          (vif.soap),
        .timerbegin    (vif.timerbegin),
        .fillwater     (vif.fillwater),
        .refill        (vif.refill),
        .drain         (vif.drain),
        .timercounter (vif.timercounter)
    );

    // CLOCK
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Assertions: bound into the DUT so they can see its internal state.
    bind washer Assertion u_assertion (
        .clk         (clk),
        .rst         (rst),
        .coin        (coin),
        .wet         (wet),
        .soap        (soap),
        .state       (cst),
        .timerbegin  (timerbegin),
        .fillwater   (fillwater),
        .refill      (refill),
        .drain       (drain),
        .timercounter(timercounter)
    );

    // RESET + INPUT INITIALIZATION
    // Reset is released at t=22 (clock: posedge @5,15,25 / negedge @10,20,30),
    // i.e. away from any clock edge, so the driver and monitor (which both
    // work on negedge) never race with the reset release.
    initial begin
        vif.rst  = 1'b1;
        vif.coin = 1'b0;
        vif.wet  = 1'b0;
        vif.soap = 1'b0;

        #22;

        vif.rst = 1'b0;
    end

    // UVM CONFIGURATION
    initial begin
        uvm_config_db #(virtual washer_if)::set(
            null,
            "*",
            "vif",
            vif
        );

        run_test("Test");
    end

endmodule
