module reg_64(read_out, data_in,clock, r);

//input enable is the same as write enable
//output_enable is same as read enable
    input r, clock;
    input [63:0] data_in;
    wire [63:0] outDff;
    output [63:0] read_out;


    

    genvar i;
    for (i=0; i<64; i=i+1) begin: loop1
        dffe_ref a_dff(.q(outDff[i]), .d(data_in[i]), .clk(clock), .en(1'b1), .clr(r));
        my_tri tristate(.in(outDff[i]), .oe(1'b1), .out(read_out[i]));
    end


endmodule
