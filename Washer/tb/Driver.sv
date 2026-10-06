class Driver extends uvm_driver #(Transaction);

`uvm_component_utils(Driver)

virtual washer_if vif;

function new(string name = "Driver" , uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(virtual washer_if)::get(this , "" , "vif" , vif))
`uvm_fatal("Driver","virtual interface not found")
endfunction

task run_phase(uvm_phase phase);

    // Do not drive stimulus while the DUT is still in reset
    @(negedge vif.clk);
    while (vif.rst !== 1'b0)
        @(negedge vif.clk);

    forever begin

        seq_item_port.get_next_item(req);

        @(negedge vif.clk);

        vif.coin <= req.coin;
        vif.wet  <= req.wet;
        vif.soap <= req.soap;

        @(posedge vif.clk);

        seq_item_port.item_done();

    end

endtask
endclass
