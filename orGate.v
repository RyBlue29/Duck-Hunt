module orGate(out, in1, in2);
        
    input [31:0] in1;
    input [31:0] in2;


    output [31:0] out;

    or OR1(out[0], in1[0], in2[0]);
    or OR2(out[1], in1[1], in2[1]);
    or OR3(out[2], in1[2], in2[2]);
    or OR4(out[3], in1[3], in2[3]);
    or OR5(out[4], in1[4], in2[4]);
    or OR6(out[5], in1[5], in2[5]);
    or OR7(out[6], in1[6], in2[6]);
    or OR8(out[7], in1[7], in2[7]);
    or OR9(out[8], in1[8], in2[8]);
    or OR10(out[9], in1[9], in2[9]);
    or OR11(out[10], in1[10], in2[10]);
    or OR12(out[11], in1[11], in2[11]);
    or OR13(out[12], in1[12], in2[12]);
    or OR14(out[13], in1[13], in2[13]);
    or OR15(out[14], in1[14], in2[14]);
    or OR16(out[15], in1[15], in2[15]);
    or OR17(out[16], in1[16], in2[16]);
    or OR18(out[17], in1[17], in2[17]);
    or OR19(out[18], in1[18], in2[18]);
    or OR20(out[19], in1[19], in2[19]);
    or OR21(out[20], in1[20], in2[20]);
    or OR22(out[21], in1[21], in2[21]);
    or OR23(out[22], in1[22], in2[22]);
    or OR24(out[23], in1[23], in2[23]);
    or OR25(out[24], in1[24], in2[24]);
    or OR26(out[25], in1[25], in2[25]);
    or OR27(out[26], in1[26], in2[26]);
    or OR28(out[27], in1[27], in2[27]);
    or OR29(out[28], in1[28], in2[28]);
    or OR30(out[29], in1[29], in2[29]);
    or OR31(out[30], in1[30], in2[30]);
    or OR32(out[31], in1[31], in2[31]);
    
    // add your code here:

endmodule