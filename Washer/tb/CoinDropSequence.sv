// Second directed sequence: drops coin in the middle of WASH.
//
// RTL behaviour this exercises: timercounter is cleared on every clock where
// coin is low, so a coin drop in WASH restarts the 31-count and the machine
// just waits in WASH until coin comes back and the timer reaches 31 again.
// Also holds RINSE and DRY with their exit conditions false.
//
// Assumes the DUT is in IDLE at start (previous sequence ends in IDLE),
// and leaves it in IDLE.
class CoinDropSequence extends uvm_sequence #(Transaction);

    `uvm_object_utils(CoinDropSequence)

    function new(string name = "CoinDropSequence");
        super.new(name);
    endfunction

    // Drive the given input values for n clock cycles
    task drive(bit c, bit w, bit s, int n = 1);
        Transaction tr;
        repeat (n) begin
            tr = Transaction::type_id::create("tr");
            start_item(tr);
            tr.coin = c;
            tr.wet  = w;
            tr.soap = s;
            finish_item(tr);
        end
    endtask

    task body();

        // IDLE -> COUNTER -> WASH
        drive(1, 1, 1, 2);

        // Let the timer run for a while inside WASH
        drive(1, 1, 1, 10);

        // Drop coin (soap still high): timer clears, DUT must stay in WASH
        drive(0, 1, 1, 5);

        // Coin back: timer restarts from 0, WASH must last the full count
        // (32 clocks of coin to leave WASH, a few extra ones spent in RINSE)
        drive(1, 1, 1, 34);

        // RINSE must hold while soap is high, whatever coin does
        drive(0, 1, 1, 3);

        // soap gone -> DRY
        drive(0, 1, 0, 1);

        // DRY must hold while wet is high
        drive(0, 1, 0, 3);

        // wet gone -> IDLE, then stay quiet
        drive(0, 0, 0, 2);

    endtask

endclass
