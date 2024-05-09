module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] in_reg, out_reg, write_decode_out, fin_write_enable, before_tristate, readA_decode_out, readB_decode_out;
	wire [31:0] out_write_in_read[31:0];

	// add your code here
	decoder_32 writeDecode(write_decode_out, ctrl_writeReg);

	decoder_32 readDecode1(readA_decode_out, ctrl_readRegA);
	decoder_32 readDecode2(readB_decode_out, ctrl_readRegB);

	my_reg a_reg0(.read_out(out_write_in_read[0]), .write_in(data_writeReg), .in_enable(1'd0), .out_enable(1'd1), .clock(clock), .r(ctrl_reset));
	tri_32 readA0(.in(out_write_in_read[0]), .oe(readA_decode_out[0]), .out(data_readRegA));
	tri_32 readB0(.in(out_write_in_read[0]), .oe(readB_decode_out[0]), .out(data_readRegB));


	genvar i;
	for (i=1; i<32; i=i+1) begin: loop2
		and write_enable_check(fin_write_enable[i], ctrl_writeEnable, write_decode_out[i]);

		my_reg a_reg(.read_out(out_write_in_read[i]), .write_in(data_writeReg), .in_enable(fin_write_enable[i]), .out_enable(1'd1), .clock(clock), .r(ctrl_reset));

		tri_32 readA(.in(out_write_in_read[i]), .oe(readA_decode_out[i]), .out(data_readRegA));
		tri_32 readB(.in(out_write_in_read[i]), .oe(readB_decode_out[i]), .out(data_readRegB));
	end

endmodule
