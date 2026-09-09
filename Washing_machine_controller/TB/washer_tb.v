module washer_tb;

    reg clk;
    reg rst;
    reg coin;
    reg wet;
    reg soap;

    wire Timerbegin;
    wire Fillwater;
    wire Refill;
    wire Drain;
    wire [4:0] timer_counter;

    // DUT instantiation
    washer m1 (
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .wet(wet),
        .soap(soap),
        .Timerbegin(Timerbegin),
        .Fillwater(Fillwater),
        .Refill(Refill),
        .Drain(Drain),
        .timer_counter(timer_counter)
    );

    // ------------------------------------------------
    // Clock Generation
    // ------------------------------------------------
    initial
    begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ------------------------------------------------
    // Initialize Inputs
    // ------------------------------------------------
    task initialize;
    begin
        rst  = 1'b0;
        coin = 1'b0;
        wet  = 1'b0;
        soap = 1'b0;
    end
    endtask

    // ------------------------------------------------
    // Reset
    // ------------------------------------------------
    task reset;
    begin
        @(negedge clk);
        rst = 1'b1;

        @(negedge clk);
        rst = 1'b0;
    end
    endtask

    // ------------------------------------------------
    // Apply Inputs
    // ------------------------------------------------
    task inputs(input c, w, s);
    begin
        @(negedge clk);
        coin = c;
        wet  = w;
        soap = s;
    end
    endtask

    // ------------------------------------------------
    // Wait for Counter
    // ------------------------------------------------
    task counter;
    begin
        repeat (31)
        begin
            @(posedge clk);
        end
    end
    endtask

    // ------------------------------------------------
    // Waveform Dump
    // ------------------------------------------------
    initial
    begin
        $dumpfile("wave.vcd");
        $dumpvars(0, washer_tb);
    end

    // ------------------------------------------------
    // Test Sequence
    // ------------------------------------------------
    initial
    begin
        initialize;

        reset;

        // Insert coin and start washing
        inputs(1'b1, 1'b0, 1'b0);

        // Wait for timer
        counter;

        // Stop coin input
        inputs(1'b0, 1'b0, 1'b0);

        // Rinse
        inputs(1'b0, 1'b0, 1'b0);

        // Dry
        inputs(1'b0, 1'b0, 1'b0);

        #1000;

        $finish;
    end

endmodule

