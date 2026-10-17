`timescale 1ns/1ps

module testbench;
    localparam int DATA_WIDTH = 8;
    localparam int FIFO_DEPTH = 16;

    logic clk;
    logic rst_n;

    // Write_interface
    logic                    push;
    logic [DATA_WIDTH - 1:0] data_in;
    logic                    full;

    // Read_interface
    logic                    pop;
    logic [DATA_WIDTH - 1:0] data_out;
    logic                    empty;

    fifo # (
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) fifo_inst (
        .clk(clk),
        .rst_n(rst_n),

        // Write_interface
        .push(push),
        .data_in(data_in),
        .full(full),

        // Read_interface
        .pop(pop), 
        .data_out(data_out),
        .empty(empty)

    );

    initial begin 
        clk = 1'b0;
        forever #5 clk = ~clk; // 100 MHz clk
    end 

    task apply_reset();
        data_in <= 'd0;
        push <= 1'b0;
        pop <= 1'b0;

        @(posedge clk);
        rst_n <= 1'b0;

        repeat (3) @(posedge clk);
        rst_n <= 1'b1;
        @(posedge clk);
    endtask

    task write(input logic [DATA_WIDTH - 1:0] data);
        @(posedge clk);
        data_in <= data;
        push <= 1'b1;

        @(posedge clk);
        data_in <= 'd0;
        push <= 1'b0;
    endtask 

    task read(output logic [DATA_WIDTH - 1:0] data);
        @(posedge clk);
        pop <= 1'b1;
        @(posedge clk);
        data = data_out;
        pop <= 1'b0;
    endtask

    task check_data(input logic [DATA_WIDTH - 1:0] data_expected,
                         input logic [DATA_WIDTH - 1:0] data_got,
                         input string msg);
        if (data_expected !== data_got) begin
            $error("Error: [%0t] %s exp=%h got=%h", $time, msg, data_expected, data_got);
        end else begin
            $display("OK: [%0t] %s exp=%h got=%h", $time, msg, data_expected, data_got);
        end
    endtask

    logic [DATA_WIDTH - 1:0] data_tmp;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        apply_reset();

        // Smoke test
        write('d1);
        read(data_tmp);
        check_data('d1, data_tmp, "smoke_test");

        // Full test 
        for (int i = 0; i < FIFO_DEPTH; i++) begin
            write('d1);
        end
        @(posedge clk); // wait for end of write operation
        check_data(1'b1, full, "full_flag_test");

        // Empty test
        for (int i = 0; i <  FIFO_DEPTH; i++) begin
            read(data_tmp);
        end
        @(posedge clk); // wait for end of read operation
        check_data(1'b1, empty, "empty_flag_test");

        #50;
        $finish;

    end

endmodule 
