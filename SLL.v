module SLL(out, in, shamt);
    
    input [31:0] in;
    input [4:0] shamt;
    wire [31:0] out16, out8, out4, out2, in8, in4, in2, in1, out1;
   
    

    output [31:0] out;
   
    

//shift by 16
assign out16[31:0] = {in[15:0], 16'b0};
mux_2 mu16(in8[31:0], shamt[4], out16[31:0], in[31:0]);

//shift by 8
assign out8[31:0] = {in8[23:0], 8'b0};
mux_2 mu8(in4[31:0], shamt[3], out8[31:0], in8[31:0]);

//shift by 4
assign out4[31:0] = {in4[27:0], 4'b0};
mux_2 mu4(in2[31:0], shamt[2], out4[31:0], in4[31:0]);


//shift by 2
assign out2[31:0] = {in2[29:0], 2'b0};
mux_2 mu2(in1[31:0], shamt[1], out2[31:0], in2[31:0]);


//shift by 1
assign out1[31:0] = {in1[30:0], 1'b0};
mux_2 mu1(out[31:0], shamt[0], out1[31:0], in1[31:0]);

endmodule