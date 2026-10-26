interface fifo_if import fifo_cfg_pkg::*; (input bit clk);
    logic                    rst_n;
    logic                    push;
    logic [DATA_WIDTH - 1:0] data_in;
    logic                    full;
    logic                    pop;
    logic [DATA_WIDTH - 1:0] data_out;
    logic                    empty;
endinterface