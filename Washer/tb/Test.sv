class Test extends uvm_test;

    `uvm_component_utils(Test)

    Env env;
    Sequence seq;
    CoinDropSequence seq2;

    function new(string name = "Test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = Env::type_id::create("env", this);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = Sequence::type_id::create("seq");

        seq.start(env.agent.seqr);

        seq2 = CoinDropSequence::type_id::create("seq2");

        seq2.start(env.agent.seqr);

        // Let the monitor/scoreboard see the final transitions
        #50;

        phase.drop_objection(this);

    endtask

endclass
