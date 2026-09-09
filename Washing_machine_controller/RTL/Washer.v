module washer (
    input        clk,
    input        rst,
    input        coin,
    input        wet,
    input        soap,

    output       Timerbegin,
    output       Fillwater,
    output       Refill,
    output       Drain,
    output reg [4:0] timer_counter
);

    reg [2:0] cst, nst;

    // State assignment
    parameter IDLE    = 3'b000,
              COUNTER = 3'b001,
              WASH    = 3'b010,
              RINSE   = 3'b011,
              DRY     = 3'b100;

    // ------------------------------------------------
    // Timer Counter
    // ------------------------------------------------
    always @(posedge clk)
    begin
        if (rst)
            timer_counter <= 5'd0;
        else if (coin == 1'b1)
            timer_counter <= timer_counter + 1'b1;
        else
            timer_counter <= 5'd0;
    end

    // ------------------------------------------------
    // Current State Logic
    // ------------------------------------------------
    always @(posedge clk)
    begin
        if (rst)
            cst <= IDLE;
        else
            cst <= nst;
    end

    // ------------------------------------------------
    // Next State Logic
    // ------------------------------------------------
    always @(*)
    begin
        case (cst)

            IDLE:
            begin
                if (coin == 1'b1)
                    nst = COUNTER;
                else
                    nst = IDLE;
            end

            COUNTER:
            begin
                nst = WASH;
            end

            WASH:
            begin
                if (timer_counter > 5'd30)
                    nst = RINSE;
                else
                    nst = WASH;
            end

            RINSE:
            begin
                if (soap == 1'b0)
                    nst = DRY;
                else
                    nst = RINSE;
            end

            DRY:
            begin
                if (wet == 1'b0)
                    nst = IDLE;
                else
                    nst = DRY;
            end

            default:
            begin
                nst = IDLE;
            end

        endcase
    end

    // ------------------------------------------------
    // Output Logic
    // ------------------------------------------------
    assign Timerbegin = (cst == COUNTER);
    assign Fillwater  = (cst == WASH);
    assign Refill     = (cst == RINSE);
    assign Drain      = (cst == DRY);

endmodule


