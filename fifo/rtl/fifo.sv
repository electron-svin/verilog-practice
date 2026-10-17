`timescale 1ns/1ps


module fifo # (
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
) (
    input  logic                    clk,
    input  logic                    rst_n,

    // Write_interface
    input  logic                    push,
    input  logic [DATA_WIDTH - 1:0] data_in,
    output logic                    full,

    // Read_interface
    input  logic                    pop, 
    output logic [DATA_WIDTH - 1:0] data_out,
    output logic                    empty

);

localparam PTR_WIDTH = $clog2(FIFO_DEPTH);

logic [DATA_WIDTH -1:0] fifo_buffer [FIFO_DEPTH - 1:0];
logic [PTR_WIDTH - 1:0] write_ptr;
logic [PTR_WIDTH- 1:0] read_ptr;

logic [PTR_WIDTH - 1:0] new_write_ptr;
logic [PTR_WIDTH - 1:0] new_read_ptr;

logic write_ptr_parity;
logic read_ptr_parity;

logic new_write_ptr_parity;
logic new_read_ptr_parity;


// Push/pop logic for new pointers
always_comb begin
    new_write_ptr = write_ptr;
    new_read_ptr = read_ptr;
    new_write_ptr_parity = write_ptr_parity;
    new_read_ptr_parity = read_ptr_parity;

    if (push & ~full) begin
        if (write_ptr == PTR_WIDTH'(FIFO_DEPTH - 1)) begin
            new_write_ptr = 'd0;
            new_write_ptr_parity = ~write_ptr_parity;
        end else begin
            new_write_ptr = write_ptr + 'd1;
        end
    end 

    if (pop & ~empty) begin
        if (read_ptr == PTR_WIDTH'(FIFO_DEPTH - 1)) begin
            new_read_ptr = 'd0;
            new_read_ptr_parity = ~read_ptr_parity;
        end else begin
            new_read_ptr = read_ptr + 'd1;
        end
    end
end

// Sequential logic 
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        write_ptr <= '0;
        read_ptr <= '0;
        write_ptr_parity <= 1'b0;
        read_ptr_parity <= 1'b0;
    end else begin
        write_ptr <= new_write_ptr;
        read_ptr <= new_read_ptr;
        write_ptr_parity <= new_write_ptr_parity;
        read_ptr_parity <= new_read_ptr_parity;
    end
end

// Write/read transaction

always_ff @(posedge clk) begin
    if (push & ~full) begin
            fifo_buffer[write_ptr] <= data_in;
    end
end

assign data_out = fifo_buffer[read_ptr];

// Empty/full logic

logic equal_ptr;
logic equal_parity;
assign equal_ptr = read_ptr == write_ptr;
assign equal_parity = read_ptr_parity == write_ptr_parity;
assign full = equal_ptr & ~equal_parity;
assign empty = equal_ptr & equal_parity;

endmodule 