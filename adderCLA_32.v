module CLA_32(sum, Cout, A, B, Cin);
    
    input [31:0] A, B;
    input Cin;
    output [31:0] sum;
    output Cout;
    wire G0, G1, G2, G3, P0, P1, P2, P3;
    wire c8, c16, c24, c32;
    wire c8_0, c16_0, c16_1, c24_0, c24_1, c24_2, c32_0, c32_1, c32_2, c32_3;
    wire nA, nB, nS, w1, w2;

    cla_8 block0(sum[7:0], G0, P0, A[7:0], B[7:0], Cin);

    and c8_in0(c8_0, P0, Cin);
    or c8_out(c8, G0, c8_0);

    cla_8 block1(sum[15:8], G1, P1, A[15:8], B[15:8], c8);

    and c16_in0(c16_0, P1, P0, Cin);
    and c16_in1(c16_1, P1, G0);
    or c16_out(c16, G1, c16_1, c16_0);

    cla_8 block2(sum[23:16], G2, P2, A[23:16], B[23:16], c16);

    and c24_in0(c24_0, P2, P1, P0, Cin);
    and c24_in1(c24_1, P2, P1, G0);
    and c24_in2(c24_2, P2, G1);
    or c24_out(c24, G2, c24_2, c24_1, c24_0);

    cla_8 block3(sum[31:24], G3, P3, A[31:24], B[31:24], c24);

    and c32_in0(c32_0, P3, P2, P1, P0, Cin);
    and c32_in1(c32_1, P3, P2, P1, G0);
    and c32_in2(c32_2, P3, P2, G1);
    and c32_in3(c32_3, P3, G2);
    or c32_out(c32, G3, c32_3, c32_2, c32_1, c32_0);

    not notA(nA, A[31]);
    not notB(nB, B[31]);
    not notS(nS, sum[31]);
    and and1(w1, nA, nB, sum[31]);
    and and2(w2, A[31], B[31], nS);
    or ovf(Cout, w1, w2);

endmodule