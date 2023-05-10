`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/06 19:52:51
// Design Name: 
// Module Name: i2c_fifo_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module i2c_fifo_master(
    input wire logic_clk_in,
    input wire i2c_clk_in,
    input wire reset_in,
    input wire [6:0] addr_in,
    input wire [7:0] data_in,
    inout wire  i2c_sda_inout,
    inout wire  i2c_scl_inout,
    output wire fifo_full,
    output wire ready_out
    );
    
wire fifo_empty;
wire [14:0] fifo_data_in;
wire [14:0] fifo_data_out;

reg start=0;


assign fifo_data_in = { addr_in, data_in };    
    
i2c_fifo i2c_fifo (
    .rst(reset_in),
    .wr_clk(logic_clk_in),
    .rd_clk(i2c_clk_in),
    .din(fifo_data_in),
    .wr_en(start),
    .rd_en(fifo_master_start),
    .dout(fifo_data_out),
    .full(fifo_full),
    .empty(fifo_empty)
    );
   
wire fifo_master_start;
wire fifo_master_ready;

assign fifo_master_start = ~fifo_empty & fifo_master_ready;

step3 master (
    .clk(clk_in),
    .reset(reset_in),
    .start(fifo_master_start),
    .addr(fifo_data_out[14:8]),
    .data(fifo_data_out[7:0]),
    .i2c_sda(i2c_sda_inout),
    .i2c_scl(i2c_scl_inout),
    .ready(fifo_master_ready)
    );    
    
   
endmodule
