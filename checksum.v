module checksum(out, sum);
        
    input [31:0] sum;


    output out;
    wire w1, w2, w3, w4, w5;

    or or1(w1, sum[0], sum[1],sum[2], sum[3], sum[4], sum[5], sum[6], sum[7]);
    or or2(w2, sum[8], sum[9], sum[10], sum[11], sum[12], sum[13], sum[14], sum[15]);
    or or3(w3, sum[16], sum[17], sum[18], sum[19], sum[20], sum[21], sum[22], sum[23]);
    or or4(w4, sum[24], sum[25],sum[26], sum[27], sum[28], sum[29], sum[30], sum[31]);
   
    
    or or5(out,w1,w2,w3,w4);
    
    // add your code here:

endmodule