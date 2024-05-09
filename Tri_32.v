module tri_32(in, oe, out);
    input [31:0] in;
    input oe;
    output [31:0] out;
    //if enable high, set out to in, if low, set out to high impedence
    assign out = oe ? in : 32'bz;
endmodule