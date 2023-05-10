module step1(

    input wire clk,
    input wire rst,
    output reg i2c_sda,
    output reg i2c_scl


);

//goal to write to device adderss 0x50, 0xaa

localparam STATE_IDLE   = 0;
localparam STATE_START  = 1;
localparam STATE_ADDR   = 2;
localparam STATE_RW     = 3;
localparam STATE_WACK   = 4;
localparam STATE_DATA   = 5;
localparam STATE_STOP   = 6;
localparam STATE_WACK2  = 7;


reg [7:0] state;
reg [6:0] addr;
reg [7:0] count;
reg [7:0] data;

    always @(posedge clk) begin
        if (rst == 1) begin
            state   <= 0;
            i2c_sda <= 1;
            i2c_scl <= 1;
            addr    <= 7'h50;
            count   <= 8'd0;
            data    <= 8'haa;
        end
        else begin
            case (state) 

                STATE_IDLE :  begin // idle
                    i2c_sda <= 1;
                    state   <= STATE_START;
                end

                STATE_START :  begin // start
                    i2c_sda <= 1;
                    state   <= STATE_ADDR;
                    count   <= 6;
                end
        
                STATE_ADDR :  begin // msb address bit
                    i2c_sda <= addr[count];
                    if (count == 0) state <= STATE_RW;
                    else            count <= count -1;
                end

                
                STATE_RW :  begin // bit5
                    i2c_sda <= 1;
                    state   <= STATE_START;
                end

                
                STATE_WACK :  begin // bit4
                    state   <= STATE_START;
                    count   <= 7;
                end

                STATE_DATA : begin 
                    i2c_sda <= data[count];
                    if (count == 0) state <= STATE_WACK;
                    else            count <= count -1;
                end

                STATE_WACK2 : begin // state wack2
                    state <= STATE_STOP;
                end

                STATE_STOP : begin //state stop
                    i2c_sda <= 1;
                    state   <= STATE_IDLE;
                end


            endcase
        end

    end

endmodule

module tb;

    reg clk;
    reg rst;
    wire i2c_sda;
    wire i2c_scl;

    step1 u0(.clk(clk), .rst(rst), .i2c_sda(i2c_sda), .i2c_scl(i2c_scl));
    
    // initial begin
    //     i2c_scl = 0;
    //     #5 forever i2c_clk = ~i2c_clk;

    // end

    
    initial begin
        clk = 0;
        #5 forever clk = ~clk;

    end

    initial begin
        rst = 1;
        #10
        rst = 0;
        #5
        rst = 1;
        $finish;
    end

    initial begin
        $dumpfile("step1.vcd");
        $dumpvars;

    end



endmodule