
`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
module step3(
    input wire clk,
    input wire reset,
    input wire start,
    input wire  [6:0] addr,
    input wire  [7:0] data,
    output reg i2c_sda,
    output wire i2c_scl,
    output wire ready
    );

    reg [7:0] state;
    reg [7:0] count;
	reg [7:0] data1;
	reg i2c_scl_enable = 0;
	
	reg [6:0] saved_addr;
	reg [7:0] saved_data;

    localparam STATE_IDLE = 0;
    localparam STATE_START = 1;
    localparam STATE_ADDR = 2;
    localparam STATE_RW = 3;
    localparam STATE_WACK = 4;
    localparam STATE_DATA = 5;
    localparam STATE_STOP = 6;
    localparam STATE_WACK2 = 7;

assign i2c_scl = (i2c_scl_enable == 0)? 1: clk;
assign ready = ((reset == 0) && (state == STATE_IDLE)) ? 1: 0;
    
    always@(negedge clk) begin  
        if (reset) begin
            i2c_scl_enable <= 0;
        end else begin
            if ((state == STATE_IDLE) || (state == STATE_START) || (state == STATE_STOP)) begin
            i2c_scl_enable <= 0;
            end
            else begin
                i2c_scl_enable <= 1;
                end
        end
        end
    

    always@(posedge clk) begin
        if (reset) begin
            state <= 0;
            i2c_sda <= 1;

        end
        else begin
            case(state)

            STATE_IDLE: begin
                i2c_sda <= 1;
                if (start) begin
                    state <= STATE_START;
                    saved_addr <= addr;
                    saved_data <= data;
                   end
                   
                else state <= STATE_IDLE;
            end

            STATE_START: begin
                i2c_sda <= 0;
                state <= STATE_ADDR;
                count <= 6;
            end

            STATE_ADDR: begin
                i2c_sda <= saved_addr[count];
                if (count == 0) state <= STATE_RW;
                else count <= count -1;
            end

            STATE_RW: begin
                i2c_sda <= 1;
                state <= STATE_WACK;
            end

            STATE_WACK: begin
                state <= STATE_DATA;
                count <= 7;
            end

            STATE_DATA: begin
                i2c_sda <= saved_data[count];
                if (count == 0) state <= STATE_WACK2;
                count <= count -1;
            end
             
             STATE_WACK2: begin
                state <= STATE_STOP;
             end

             STATE_STOP: begin
                i2c_sda <= 1;
                state <= STATE_IDLE;
             end

			endcase
		  end

	end





endmodule

