class Sequence extends uvm_sequence #(Transaction);

    `uvm_object_utils(Sequence)

    function new(string name = "Sequence");
        super.new(name);
    endfunction

    task body();

        Transaction tr;

        // Reset/start condition
        tr = Transaction::type_id::create("tr");

        start_item(tr);
        tr.coin = 1'b1;
        tr.wet  = 1'b1;
        tr.soap = 1'b1;
        finish_item(tr);

        // Keep coin HIGH so timer can increase
        repeat (35) begin

            tr = Transaction::type_id::create("tr");

            start_item(tr);
            tr.coin = 1'b1;
            tr.wet  = 1'b1;
            tr.soap = 1'b1;
            finish_item(tr);

        end

        // Move from RINSE -> DRY
        tr = Transaction::type_id::create("tr");

        start_item(tr);
        tr.coin = 1'b1;
        tr.wet  = 1'b1;
        tr.soap = 1'b0;
        finish_item(tr);

        // Move from DRY -> IDLE
        tr = Transaction::type_id::create("tr");

        start_item(tr);
        tr.coin = 1'b1;
        tr.wet  = 1'b0;
        tr.soap = 1'b0;
        finish_item(tr);

        // Return to a quiet state: coin low, so the DUT stays in IDLE
        tr = Transaction::type_id::create("tr");

        start_item(tr);
        tr.coin = 1'b0;
        tr.wet  = 1'b0;
        tr.soap = 1'b0;
        finish_item(tr);

    endtask

endclass
