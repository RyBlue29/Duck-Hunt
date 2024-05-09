module counter32(out, clk, en, clr);
   
   //Inputs
   input clk, en, clr;
   
   //Internal wire
   wire clr;
   wire w1, w2, w3, w4;

   //Output
   output [5:0] out;

    tff t1(out[0], 1'd1, clk, en, clr);
    tff t2(out[1], out[0], clk, en, clr);
    assign w1 = out[0] & out[1];

    tff t3(out[2], w1, clk, en, clr);
    assign w2 = w1 & out[2];

    tff t4(out[3],w2, clk, en, clr );
    assign w3 = w2 & out[3];

    tff t5(out[4], w3, clk, en, clr);
    assign w4 = w3 & out[4];

    tff t6(out[5], w4, clk, en, clr);
    


endmodule
   