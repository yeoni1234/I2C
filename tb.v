`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/06 17:10:23
// Design Name: 
// Module Name: test_step1
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


module test_step3;

reg clk;
reg reset;
reg start;
reg [6:0] addr_in;
reg [7:0] data_in;

wire i2c_sda;
wire i2c_scl;
wire i2c_clk;
wire fifo_full;
wire ready_out;

 
 i2c_clk_divider #(.DELAY(1000)) uut2 (
    .reset(reset),
    .ref_clk(clk),
    .i2c_clk(i2c_clk)
    );
 
i2c_fifo_master fifo_master (
    .logic_clk_in(clk),
    .i2c_clk_in(i2c_clk),
    .reset_in(reset),
    .start(start),
    .addr_in(addr_in),
    .data_in(data_in),
    .i2c_sda_inout(i2c_sda),
    .i2c_scl_inout(i2c_scl),
    .fifo_full(fifo_full),
    .ready_out(ready_out)
    );
 
 
 initial begin
    clk = 0;
    forever begin
        clk = #5 ~clk;
        end
        end
        
        initial begin
        reset = 1;
        
        #10000;
      
        reset = 0;
        
        #100;
        @ (negedge clk);
        addr_in = 7'h55;
        data_in = 8'haa;
        start = 1;
        
        @ (negedge clk);
        addr_in = 7'h55;
        data_in = 8'h01;
        start = 1;
        
        @ (negedge clk);
        addr_in = 7'h55;
        data_in = 8'hd3;
        start = 1;
        
        $finish;
        end
endmodule
