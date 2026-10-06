class Env extends uvm_env;

    `uvm_component_utils(Env)

    Agent      agent;
    Scoreboard scoreboard;
    Coverage   coverage;

    function new(string name = "Env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent      = Agent::type_id::create("agent", this);
        scoreboard = Scoreboard::type_id::create("scoreboard", this);
        coverage   = Coverage::type_id::create("coverage", this);

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agent.mon.a_port.connect(scoreboard.a_imp);
        agent.mon.a_port.connect(coverage.analysis_export);

    endfunction

endclass
