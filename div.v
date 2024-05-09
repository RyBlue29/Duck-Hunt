module div(result, data_res_rdy, div_ovf, dividend, divisor, clk, reset);

    input [31:0] dividend, divisor;
    input clk, reset;
    wire [31:0] pos_dividend, pos_divisor;
    wire sign;

    mux_2 negdividend(pos_dividend, dividend[31], -dividend, dividend);
    mux_2 negdivisor(pos_divisor, divisor[31], -divisor, divisor);
    assign sign = dividend[31] ^ divisor[31] ?  1'b1 : 1'b0;

    output [31:0] result;
    output div_ovf, data_res_rdy;

    // add your code here
    wire cOUT, first_cycle;
    wire [63:0] quotient_reg, next_reg, data_in_reg;
    wire [31:0] to_add, sum, correct_signed;
    wire div_select;

    div_ctrl div_control(data_res_rdy, to_add, first_cycle, div_select, pos_divisor, clk, reset);

    assign next_reg[31:0]  =  first_cycle ? pos_dividend : {quotient_reg[31:1], ~next_reg[63]};
    assign next_reg[63:32] =  first_cycle ? 32'b0 : sum;
    
    assign data_in_reg = next_reg << 1;

    reg_64 RQ(.read_out(quotient_reg), .data_in(data_in_reg), .clock(clk), .r(reset));
    CLA_32 adder32bit(sum, cOUT, quotient_reg[63:32], to_add, 1'b0);
    

    assign correct_signed = sign ? -next_reg[31:0] : next_reg[31:0];
    assign result = div_ovf ? 32'd0 : correct_signed;

    assign div_select = quotient_reg[63];


    wire ze0, ze1, ze2, ze3, divisor_zero;
    assign ze0 = divisor[0] | divisor[31] | divisor[30] | divisor[29] | divisor[28] | divisor[27] | divisor[26] | divisor[25];
    assign ze1 = divisor[24] | divisor[23] | divisor[22] | divisor[21] | divisor[20] | divisor[19] | divisor[18] | divisor[17];
    assign ze2 = divisor[16] | divisor[15] | divisor[14] | divisor[13] | divisor[12] | divisor[11] | divisor[10] | divisor[9];
    assign ze3 = divisor[8] | divisor[7] | divisor[6] | divisor[5] | divisor[4] | divisor[3] | divisor[2] | divisor[1];
    assign divisor_zero = ~(ze0 | ze1 | ze2 | ze3);

    assign div_ovf = divisor_zero;
   

   
endmodule