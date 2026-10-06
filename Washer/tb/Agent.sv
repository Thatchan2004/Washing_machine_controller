class Agent extends uvm_agent;

    `uvm_component_utils(Agent)

    Sequencer seqr;
    Driver    drv;
    Monitor   mon;

    function new(string name = "Agent",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        seqr = Sequencer::type_id::create("seqr", this);
        drv  = Driver::type_id::create("drv", this);
        mon  = Monitor::type_id::create("mon", this);

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        drv.seq_item_port.connect(seqr.seq_item_export);

    endfunction

endclass
