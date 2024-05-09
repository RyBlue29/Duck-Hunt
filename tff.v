module tff(q, t, clk, en, clr);
   
   //Inputs
   input t, clk, en, clr;
   
   //Internal wire
   wire clr;
   wire w1, w2, d;

   //Output
   output q;
   output qnot;

   assign w1 = !t & q;
   assign w2 = t & !q;
   assign d = w1 | w2;

   dffe_ref tflip(q, d, clk, en , clr);
   assign qnot= !q;

endmodule
   