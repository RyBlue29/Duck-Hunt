module cla_8(sum, G, P, A, B, c0);
input [7:0] A, B;
    input c0;

    output [7:0] sum;
    output G, P;
    wire a0, a1, a2, a3, a4, a5, a6, a7, b0, b1, b2, b3, b4, b5, b6, b7;
    wire p0, p1, p2, p3, p4, p5, p6, p7, g0, g1, g2, g3, g4, g5, g6, g7;
    wire c1, c2, c3, c4, c5, c6, c7;
    wire c1_0, c2_0, c2_1, c3_0, c3_1, c3_2, c4_0, c4_1, c4_2, c4_3, c5_0, c5_1, c5_2, c5_3, c5_4, c6_0, c6_1, c6_2, c6_3, c6_4, c6_5, c7_0, c7_1, c7_2, c7_3, c7_4, c7_5, c7_6;
    wire s0, s1, s2, s3, s4, s5, s6, s7;
    wire G0, G1, G2, G3, G4, G5, G6;

    assign a0 = A[0];
    assign a1 = A[1];
    assign a2 = A[2];
    assign a3 = A[3];
    assign a4 = A[4];
    assign a5 = A[5];
    assign a6 = A[6];
    assign a7 = A[7];

    assign b0 = B[0];
    assign b1 = B[1];
    assign b2 = B[2];
    assign b3 = B[3];
    assign b4 = B[4];
    assign b5 = B[5];
    assign b6 = B[6];
    assign b7 = B[7];

    assign sum[0] = s0;
    assign sum[1] = s1;
    assign sum[2] = s2;
    assign sum[3] = s3;
    assign sum[4] = s4;
    assign sum[5] = s5;
    assign sum[6] = s6;
    assign sum[7] = s7;

    or p0_or(p0, a0, b0);
    or p1_or(p1, a1, b1);
    or p2_or(p2, a2, b2);
    or p3_or(p3, a3, b3);
    or p4_or(p4, a4, b4);
    or p5_or(p5, a5, b5);
    or p6_or(p6, a6, b6);
    or p7_or(p7, a7, b7);

    and g0_and(g0, a0, b0);
    and g1_and(g1, a1, b1);
    and g2_and(g2, a2, b2);
    and g3_and(g3, a3, b3);
    and g4_and(g4, a4, b4);
    and g5_and(g5, a5, b5);
    and g6_and(g6, a6, b6);
    and g7_and(g7, a7, b7);

    and c1_in0(c1_0, p0, c0);
    or c1_out(c1, g0, c1_0);

    and c2_in0(c2_0, p1, p0, c0);
    and c2_in1(c2_1, g0, p1);
    or c2_out(c2, g1, c2_0, c2_1);

    and c3_in0(c3_0, p0, p1, p2, c0);
    and c3_in1(c3_1, g0, p1, p2);
    and c3_in2(c3_2, g1, p2);
    or c3_out(c3, g2, c3_0, c3_1, c3_2);

    and c4_in0(c4_0, p0, p1, p2, p3, c0);
    and c4_in1(c4_1, g0, p1, p2, p3);
    and c4_in2(c4_2, g1, p2, p3);
    and c4_in3(c4_3, g2, p3);
    or c4_out(c4, g3, c4_0, c4_1, c4_2, c4_3);
    
    and c5_in0(c5_0, p0, p1, p2, p3, p4, c0);
    and c5_in1(c5_1, g0, p1, p2, p3, p4);
    and c5_in2(c5_2, g1, p2, p3, p4);
    and c5_in3(c5_3, g2, p3, p4);
    and c5_in4(c5_4, g3, p4);
    or c5_out(c5, g4, c5_0, c5_1, c5_2, c5_3, c5_4);

    and c6_in0(c6_0, p0, p1, p2, p3, p4, p5, c0);
    and c6_in1(c6_1, g0, p1, p2, p3, p4, p5);
    and c6_in2(c6_2, g1, p2, p3, p4, p5);
    and c6_in3(c6_3, g2, p3, p4, p5);
    and c6_in4(c6_4, g3, p4, p5);
    and c6_in5(c6_5, g4, p5);
    or c6_out(c6, g5, c6_0, c6_1, c6_2, c6_3, c6_4, c6_5);
    
    and c7_in0(c7_0, p0, p1, p2, p3, p4, p5, p6, c0);
    and c7_in1(c7_1, g0, p1, p2, p3, p4, p5, p6);
    and c7_in2(c7_2, g1, p2, p3, p4, p5, p6);
    and c7_in3(c7_3, g2, p3, p4, p5, p6);
    and c7_in4(c7_4, g3, p4, p5, p6);
    and c7_in5(c7_5, g4, p5, p6);
    and c7_in6(c7_6, g5, p6);
    or c7_out(c7, g6, c7_0, c7_1, c7_2, c7_3, c7_4, c7_5, c7_6);

    xor(s0, a0, b0, c0);
    xor(s1, a1, b1, c1);
    xor(s2, a2, b2, c2);
    xor(s3, a3, b3, c3);
    xor(s4, a4, b4, c4);
    xor(s5, a5, b5, c5);
    xor(s6, a6, b6, c6);
    xor(s7, a7, b7, c7);

    and P_out(P, p0, p1, p2, p3, p4, p5, p6, p7);
    and G_in0(G0, g0, p1, p2, p3, p4, p5, p6, p7);
    and G_in1(G1, g1, p2, p3, p4, p5, p6, p7);
    and G_in2(G2, g2, p3, p4, p5, p6, p7);
    and G_in3(G3, g3, p4, p5, p6, p7);
    and G_in4(G4, g4, p5, p6, p7);
    and G_in5(G5, g5, p6, p7);
    and G_in6(G6, g6, p7);
    or G_out(G, g7, G6, G5, G4, G3, G2, G1, G0);

endmodule