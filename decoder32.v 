module decoder_32(out, select);
    //put write enable from reg file as the enable to this
    //select will be the crtl_write reg
    input [4:0] select;
    output [31:0] out;
    mux_32 decode(out, select, 32'd1, 
        32'd2, 
        32'd4, 
        32'd8, 
        32'd16, 
        32'd32, 
        32'd64, 
        32'd128, 
        32'd256, 
        32'd512, 
        32'd1024, 
        32'd2048, 
        32'd4096, 
        32'd8192, 
        32'd16384, 
        32'd32768, 
        32'd65536, 
        32'd131072, 
        32'd262144, 
        32'd524288, 
        32'd1048576, 
        32'd2097152, 
        32'd4194304, 
        32'd8388608, 
        32'd16777216, 
        32'd33554432, 
        32'd67108864, 
        32'd134217728, 
        32'd268435456, 
        32'd536870912, 
        32'd1073741824, 
        32'd2147483648);

endmodule