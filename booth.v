module booth(result, data_res_rdy, mult_ovf, multiplicand, multiplier, clk, reset);

    input [31:0] multiplicand, multiplier;
    input clk, reset;

    output [31:0] result;
    output mult_ovf, data_res_rdy;

    // add your code here
    wire cOUT, first_cycle;
    wire [64:0] product_reg, next_reg, data_in_reg, shifted;
    wire [31:0] to_add, sum;
    wire [2:0] booth_select;

    
    mult_cntrl mult_control(data_res_rdy, to_add, first_cycle, booth_select, multiplicand, clk, reset);


    assign next_reg[0]     =  first_cycle ? 1'b0 : product_reg[0];
    assign next_reg[32:1]  =  first_cycle ? multiplier : product_reg[32:1];
    assign next_reg[64:33] =  first_cycle ? 32'b0 : sum;

    assign shifted = $signed(next_reg[64:0]) >>> 2;
    assign data_in_reg = first_cycle ? next_reg : shifted;

    reg_65 product(.read_out(product_reg), .data_in(data_in_reg), .clock(clk), .r(reset));
    CLA_32 adder32bit(sum, cOUT, product_reg[64:33], to_add, 1'b0);

    assign result = product_reg[32:1];
    assign booth_select = product_reg[2:0];
   

    //handle multiplication overflow
    wire p0, p1, p2, p3, pos_ovf;
    assign p0 = ~product_reg[64] & ~product_reg[63] & ~product_reg[62] & ~product_reg[61] & ~product_reg[60] & ~product_reg[59] & ~product_reg[58] & ~product_reg[57];
    assign p1 = ~product_reg[56] & ~product_reg[55] & ~product_reg[54] & ~product_reg[53] & ~product_reg[52] & ~product_reg[51] & ~product_reg[50] & ~product_reg[49];
    assign p2 = ~product_reg[48] & ~product_reg[47] & ~product_reg[46] & ~product_reg[45] & ~product_reg[44] & ~product_reg[43] & ~product_reg[42] & ~product_reg[41];
    assign p3 = ~product_reg[40] & ~product_reg[39] & ~product_reg[38] & ~product_reg[37] & ~product_reg[36] & ~product_reg[35] & ~product_reg[34] & ~product_reg[33];
    assign pos_ovf = ~(~product_reg[32] & p0 & p1 & p2 & p3);

    wire n0, n1, n2, n3, neg_ovf, muxd1;
    assign n0 = product_reg[64] & product_reg[63] & product_reg[62] & product_reg[61] & product_reg[60] & product_reg[59] & product_reg[58] & product_reg[57];
    assign n1 = product_reg[56] & product_reg[55] & product_reg[54] & product_reg[53] & product_reg[52] & product_reg[51] & product_reg[50] & product_reg[49];
    assign n2 = product_reg[48] & product_reg[47] & product_reg[46] & product_reg[45] & product_reg[44] & product_reg[43] & product_reg[42] & product_reg[41];
    assign n3 = product_reg[40] & product_reg[39] & product_reg[38] & product_reg[37] & product_reg[36] & product_reg[35] & product_reg[34] & product_reg[33];
    assign neg_ovf = ~(product_reg[32] & n0 & n1 & n2 & n3);

    wire ze0, ze1, ze2, ze3, plier_zero, muxd2, muxd3;
    assign ze0 = multiplier[0] | multiplier[31] | multiplier[30] | multiplier[29] | multiplier[28] | multiplier[27] | multiplier[26] | multiplier[25];
    assign ze1 = multiplier[24] | multiplier[23] | multiplier[22] | multiplier[21] | multiplier[20] | multiplier[19] | multiplier[18] | multiplier[17];
    assign ze2 = multiplier[16] | multiplier[15] | multiplier[14] | multiplier[13] | multiplier[12] | multiplier[11] | multiplier[10] | multiplier[9];
    assign ze3 = multiplier[8] | multiplier[7] | multiplier[6] | multiplier[5] | multiplier[4] | multiplier[3] | multiplier[2] | multiplier[1];
    assign plier_zero = ~(ze0 | ze1 | ze2 | ze3);

    wire zer0, zer1, zer2, zer3, cand_zero;
    assign zer0 = multiplicand[0] | multiplicand[31] | multiplicand[30] | multiplicand[29] | multiplicand[28] | multiplicand[27] | multiplicand[26] | multiplicand[25];
    assign zer1 = multiplicand[24] | multiplicand[23] | multiplicand[22] | multiplicand[21] | multiplicand[20] | multiplicand[19] | multiplicand[18] | multiplicand[17];
    assign zer2 = multiplicand[16] | multiplicand[15] | multiplicand[14] | multiplicand[13] | multiplicand[12] | multiplicand[11] | multiplicand[10] | multiplicand[9];
    assign zer3 = multiplicand[8] | multiplicand[7] | multiplicand[6] | multiplicand[5] | multiplicand[4] | multiplicand[3] | multiplicand[2] | multiplicand[1];
    assign cand_zero = ~(zer0 | zer1 | zer2 | zer3);

    wire zero0, zero1, zero2, zero3, sum_zero;
    assign zero0 = product_reg[32] | product_reg[31] | product_reg[30] | product_reg[29] | product_reg[28] | product_reg[27] | product_reg[26] | product_reg[25];
    assign zero1 = product_reg[24] | product_reg[23] | product_reg[22] | product_reg[21] | product_reg[20] | product_reg[19] | product_reg[18] | product_reg[17];
    assign zero2 = product_reg[16] | product_reg[15] | product_reg[14] | product_reg[13] | product_reg[12] | product_reg[11] | product_reg[10] | product_reg[9];
    assign zero3 = product_reg[8] | product_reg[7] | product_reg[6] | product_reg[5] | product_reg[4] | product_reg[3] | product_reg[2] | product_reg[1];
    assign sum_zero = ~(zero0 | zero1 | zero2 | zero3);



    assign muxd1 = ((multiplicand[31] & ~multiplier[31]) | (~multiplicand[31] & multiplier[31])) ? neg_ovf: 1'b0;
    assign muxd2 = ((~multiplicand[31] & ~multiplier[31]) | (multiplicand[31] & multiplier[31])) ? pos_ovf : muxd1;
    assign muxd3 = (plier_zero | cand_zero) ? 1'b0 : muxd2;
    assign mult_ovf = (sum_zero & (~(plier_zero | cand_zero))) ? 1'b1 : muxd3;


   



    
    
    
    
   
endmodule