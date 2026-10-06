class Transaction extends uvm_sequence_item;

rand bit coin;
rand bit wet;
rand bit soap;

// Observed by the monitor only (not randomized / not driven)
bit rst;
bit timerbegin;
bit refill;
bit fillwater;
bit drain;
bit [4:0] timercounter;

`uvm_object_utils(Transaction)


function new(string name = "Transaction");
super.new(name);
endfunction
endclass
