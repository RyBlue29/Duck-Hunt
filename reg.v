module my_reg(read_out, write_in, in_enable, out_enable, clock, r);

//input enable is the same as write enable
//output_enable is same as read enable
    input in_enable, out_enable, r, clock;
    input [31:0] write_in;
    wire [31:0] outDff;
    output [31:0] read_out;


    genvar i;
    for (i=0; i<32; i=i+1) begin: loop1
        dffe_ref a_dff(.q(outDff[i]), .d(write_in[i]), .clk(clock), .en(in_enable), .clr(r));
        my_tri tristate(.in(outDff[i]), .oe(out_enable), .out(read_out[i]));
    end


endmodule
