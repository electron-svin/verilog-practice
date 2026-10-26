module tb;
    import fifo_cfg_pkg::*;
    import fifo_tb_pkg::*;

    logic clk;
    always #10 clk = ~clk;
    fifo_if _if(clk);

    fifo # (
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) u0 (
        .clk(clk),
        .rst_n(_if.rst_n),
        .push(_if.push),
        .data_in(_if.data_in),
        .full(_if.full),
        .pop(_if.pop),
        .data_out(_if.data_out),
        .empty(_if.empty)
    );

    initial begin
        test t0;

        clk <= 0;
        _if.rst_n <= 0;
        _if.pop <= 0;
        _if.push <= 0;
        #20 _if.rst_n <= 1;

        t0 = new;
        t0.e0.vif = _if;
        t0.run();

        #4000 $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end
endmodule 