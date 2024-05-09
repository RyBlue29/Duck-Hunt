`timescale 1ns / 1ps
module RAM #( parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 12, DEPTH = 20) (
    input wire                     clk,
    input wire                     wEn,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0]    dataIn,
    input wire up_sig,
    input wire down_sig,
    input wire right_sig,
    input wire left_sig,
    input wire start_game,
    input wire top_left_PT,
    input wire top_right_PT,
    input wire bottom_right_PT,
    input wire bottom_left_PT,
    output reg [DATA_WIDTH-1:0]    dataOut = 0,
    output reg mem_check,
    output reg top_left_LED,
    output reg top_right_LED, 
    output reg bottom_left_LED,
    output reg bottom_right_LED);
    
    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];
    
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            MemoryArray[i] <= 0;
        end
        // if(MEMFILE > 0) begin
        //     $readmemh(MEMFILE, MemoryArray);
        // end
    end
    reg [31:0] cycle_count;
    always @(posedge clk) begin
            MemoryArray[1] <= up_sig;
            MemoryArray[2] <= down_sig;
            MemoryArray[3] <= right_sig;
            MemoryArray[4] <= left_sig;
            MemoryArray[11] <= top_left_PT;
            MemoryArray[13] <= top_right_PT;
            MemoryArray[15] <= bottom_left_PT;
            MemoryArray[17] <= bottom_right_PT;
            mem_check <= MemoryArray[5];
            top_left_LED  <= MemoryArray[10];
            top_right_LED <= MemoryArray[12];
            bottom_left_LED <= MemoryArray[14];
            bottom_right_LED <= MemoryArray[16];
        if(wEn) begin
            MemoryArray[addr] <= dataIn;
        end else begin
            dataOut <= MemoryArray[addr];
        end if (start_game != 0 | MemoryArray[5] == 1) begin
                 if(cycle_count < 3000000000) begin
                        cycle_count <= cycle_count + 1;
                        MemoryArray[5] <= 1;
                 end else begin
                        cycle_count <= 0;
                        MemoryArray[5] <= 0;
                 end
        end
                
    end
   



endmodule
