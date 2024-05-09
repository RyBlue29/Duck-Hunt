module div_ctrl(data_res_rdy, chosen_add, first_cycle, div_select, pos_divisor, clk, reset);

    input [31:0] pos_divisor;
    input clk, reset, div_select;

    output [31:0] chosen_add;
    output data_res_rdy, first_cycle;
    wire [5:0] count;
    

    assign data_res_rdy =  (count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0]) ? 1'b1 : 1'b0;
    assign first_cycle = (~count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0]) ? 1'b1 : 1'b0;
    
    //actually booth algorithm
    mux_2 div_choose(chosen_add, div_select, pos_divisor, -pos_divisor);
    counter32 counter(count, clk, 1'b1, reset);
    

   
endmodule