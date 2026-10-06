class Monitor extends uvm_monitor;

`uvm_component_utils(Monitor)

virtual washer_if vif;

uvm_analysis_port #(Transaction) a_port;


function new(string name = "Monitor" , uvm_component parent);
super.new(name,parent);

a_port=new("a_port",this);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(virtual washer_if )::get(this , "" , "vif" , vif))
`uvm_fatal("Monitor","virtual interface not found")

endfunction

task run_phase(uvm_phase phase);

    Transaction tr;

    forever begin

        @(negedge vif.clk);

        tr = Transaction::type_id::create("tr");

        tr.rst  = vif.rst;
        tr.coin = vif.coin;
        tr.wet  = vif.wet;
        tr.soap = vif.soap;

        tr.timerbegin  = vif.timerbegin;
        tr.fillwater   = vif.fillwater;
        tr.refill      = vif.refill;
        tr.drain       = vif.drain;
        tr.timercounter = vif.timercounter;

        a_port.write(tr);

    end

endtask
endclass
