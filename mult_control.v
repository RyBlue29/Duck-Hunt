module mult_cntrl(data_res_rdy, chosen_add, first_cycle, booth_select, multiplicand, clk, reset);

    input [31:0] multiplicand;
    input [2:0] booth_select;
    input clk, reset;

    output [31:0] chosen_add;
    output data_res_rdy, first_cycle;

    wire [5:0] count;
    

    assign data_res_rdy = (~count[5] & count[4] & ~count[3] & ~count[2] & ~count[1] & count[0]) ? 1'b1 : 1'b0;
    assign first_cycle = (~count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0]) ? 1'b1 : 1'b0;

    //actually booth algorithm
    mux_8 booths_choose(.out(chosen_add), .select(booth_select[2:0]), .in0(32'd0), .in1(multiplicand), .in2(multiplicand), .in3(multiplicand<<1), .in4(-(multiplicand<<1)), .in5(-multiplicand), .in6(-multiplicand), .in7(32'd0));
    counter32 counter(count, clk, 1'b1, reset);
    

   
endmodule