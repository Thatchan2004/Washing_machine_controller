class Scoreboard extends uvm_scoreboard;

`uvm_component_utils(Scoreboard)

uvm_analysis_imp #(Transaction , Scoreboard) a_imp;

typedef enum bit [2:0] {
IDLE = 3'b000,
COUNTER=3'b001,
WASH=3'b010,
RINSE=3'b011,
DRY=3'b100
}state_t;

state_t expected_state;

bit[4:0] expected_timer;

int unsigned num_checks;
int unsigned num_errors;


function new(string name = "Scoreboard" , uvm_component parent);
super.new(name,parent);

a_imp=new("a_imp",this);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

expected_state=IDLE;
expected_timer=0;

endfunction

// Each transaction is one monitor sample, taken at negedge clk.
// It holds the inputs that were consumed by the posedge that just happened,
// together with the DUT outputs/registers after that posedge.
// So the model must advance exactly one clock edge per call, using the
// PRE-edge state and timer (like the RTL) and only then update the timer.
function void write(Transaction tr);

bit expected_timerbegin;
bit expected_refill;
bit expected_fillwater;
bit expected_drain;
bit [4:0] next_timer;

if (tr.rst) begin
    // Synchronous reset: everything returns to its initial value
    expected_state = IDLE;
    expected_timer = 5'd0;
end
else begin

    // Timer next value (same as RTL), but do NOT apply it yet:
    // the state transition below must see the pre-edge timer value.
    if (tr.coin == 1'b1)
        next_timer = expected_timer + 1'b1;
    else
        next_timer = 5'd0;

    case(expected_state)
    IDLE :
    begin
        if(tr.coin==1)
            expected_state=COUNTER;
    end

    COUNTER :
    begin
        expected_state=WASH;
    end

    WASH :
    begin
        if(expected_timer>5'd30)   // pre-edge timer, as in the RTL
            expected_state=RINSE;
    end

    RINSE:
    begin
        if(tr.soap==1'b0)
            expected_state=DRY;
    end

    DRY:
    begin
        if(tr.wet==1'b0)
            expected_state=IDLE;
    end

    default:
        expected_state=IDLE;

    endcase

    expected_timer = next_timer;
end

expected_timerbegin = (expected_state == COUNTER);
expected_fillwater  = (expected_state == WASH);
expected_refill     = (expected_state == RINSE);
expected_drain      = (expected_state == DRY);

num_checks++;

if (tr.timerbegin !== expected_timerbegin) begin
    num_errors++;
    `uvm_error("SB",
        $sformatf("Timerbegin mismatch: DUT=%0b EXP=%0b",
                  tr.timerbegin, expected_timerbegin))
end

if (tr.fillwater !== expected_fillwater) begin
    num_errors++;
    `uvm_error("SB",
        $sformatf("Fillwater mismatch: DUT=%0b EXP=%0b",
                  tr.fillwater, expected_fillwater))
end

if (tr.refill !== expected_refill) begin
    num_errors++;
    `uvm_error("SB",
        $sformatf("refill mismatch: DUT=%0b EXP=%0b",
                  tr.refill, expected_refill))
end

if (tr.drain !== expected_drain) begin
    num_errors++;
    `uvm_error("SB",
        $sformatf("Drain mismatch: DUT=%0b EXP=%0b",
                  tr.drain, expected_drain))
end

if (tr.timercounter !== expected_timer) begin
    num_errors++;
    `uvm_error("SB",
        $sformatf("Timer mismatch: DUT=%0d EXP=%0d",
                  tr.timercounter, expected_timer))
end

`uvm_info("SB",
    $sformatf("rst=%0b state=%s timer=%0d",
              tr.rst, expected_state.name(), expected_timer),
    UVM_MEDIUM)

endfunction

function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info("SB",
    $sformatf("Scoreboard done: %0d samples checked, %0d mismatches",
              num_checks, num_errors),
    UVM_NONE)
endfunction

endclass
