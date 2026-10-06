interface washer_if(input logic clk);

logic rst;
logic coin;
logic wet;
logic soap;

logic timerbegin;
logic fillwater;
logic refill;
logic drain;
logic[4:0] timercounter;

endinterface
