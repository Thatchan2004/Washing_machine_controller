class Coverage extends uvm_subscriber #(Transaction);

    `uvm_component_utils(Coverage)

    // ----------------------------------------
    // Variables used for coverage
    // ----------------------------------------

    bit coin;
    bit wet;
    bit soap;

    bit timerbegin;
    bit fillwater;
    bit refill;
    bit drain;

    bit [4:0] timercounter;

    // FSM state, decoded from the one-hot-ish outputs (0=IDLE ... 4=DRY)
    bit [2:0] state;


    // ----------------------------------------
    // Covergroup
    // ----------------------------------------

    covergroup washer_cg;

        option.per_instance = 1;

        // State coverage
        cp_state : coverpoint state {
            bins idle    = {0};
            bins counter = {1};
            bins wash    = {2};
            bins rinse   = {3};
            bins dry     = {4};
        }

        // Transition coverage (samples are consecutive clock cycles)
        cp_state_trans : coverpoint state {
            bins idle_to_counter = (0 => 1);
            bins counter_to_wash = (1 => 2);
            bins wash_to_rinse   = (2 => 3);
            bins rinse_to_dry    = (3 => 4);
            bins dry_to_idle     = (4 => 0);

            bins idle_hold  = (0 => 0);
            bins wash_hold  = (2 => 2);
            bins rinse_hold = (3 => 3);
            bins dry_hold   = (4 => 4);
        }

        // Input coverage
        cp_coin : coverpoint coin {
            bins coin_0 = {0};
            bins coin_1 = {1};
        }

        cp_wet : coverpoint wet {
            bins wet_0 = {0};
            bins wet_1 = {1};
        }

        cp_soap : coverpoint soap {
            bins soap_0 = {0};
            bins soap_1 = {1};
        }


        // Output coverage
        cp_timerbegin : coverpoint timerbegin {
            bins off = {0};
            bins on  = {1};
        }

        cp_fillwater : coverpoint fillwater {
            bins off = {0};
            bins on  = {1};
        }

        cp_refill : coverpoint refill {
            bins off = {0};
            bins on  = {1};
        }

        cp_drain : coverpoint drain {
            bins off = {0};
            bins on  = {1};
        }


        // Timer coverage
        cp_timer : coverpoint timercounter {
            bins low    = {[0:10]};
            bins medium1 = {[11:30]};
            bins high   = {[31:31]};
        }


        // Cross coverage
        coin_soap : cross coin, soap;

    endgroup


    // ----------------------------------------
    // Constructor
    // ----------------------------------------

    function new(string name = "Coverage",
                 uvm_component parent = null);

        super.new(name, parent);

        washer_cg = new();

    endfunction


    // ----------------------------------------
    // Receive transaction from monitor
    // ----------------------------------------

    function void write(Transaction t);

        // Don't count samples taken while the DUT is in reset
        if (t.rst)
            return;

        coin          = t.coin;
        wet           = t.wet;
        soap          = t.soap;

        timerbegin    = t.timerbegin;
        fillwater     = t.fillwater;
        refill        = t.refill;
        drain         = t.drain;

        timercounter = t.timercounter;

        if      (t.timerbegin) state = 3'd1;
        else if (t.fillwater)  state = 3'd2;
        else if (t.refill)     state = 3'd3;
        else if (t.drain)      state = 3'd4;
        else                   state = 3'd0;

        // Sample coverage
        washer_cg.sample();

    endfunction

    // ----------------------------------------
    // Print the result at the end of the run
    // ----------------------------------------

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COV",
            $sformatf("Functional coverage: %0.2f%%", washer_cg.get_inst_coverage()),
            UVM_NONE)
    endfunction

endclass
