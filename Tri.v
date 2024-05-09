module my_tri(in, oe, out);
    input in, oe;
    output out;
    //if enable high, set out to in, if low, set out to high impedence
    assign out = oe ? in : 1'bz;
endmodule