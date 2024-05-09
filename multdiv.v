module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here
    wire cOUT, first_cycle, mult_ovf, div_ovf, mult_op, temp_mult_ovf, temp_div_ovf, mult_result_rdy, div_result_rdy;
    wire [31:0] mult_res, div_res;

    dffe_ref mult_check(mult_op, ctrl_MULT, clock, ctrl_MULT || ctrl_DIV, 1'b0);

    booth mult(mult_res, mult_result_rdy, temp_mult_ovf, data_operandA, data_operandB, clock, ctrl_MULT);
    div divop(div_res, div_result_rdy, temp_div_ovf, data_operandA, data_operandB, clock, ctrl_DIV);

    assign data_resultRDY = (mult_result_rdy & mult_op) | (div_result_rdy & ~mult_op);

    assign div_ovf =  temp_div_ovf & div_result_rdy;
    assign mult_ovf = temp_mult_ovf & mult_result_rdy;

    assign data_result = mult_op ? mult_res: div_res;
    assign data_exception = mult_op ? mult_ovf : div_ovf;

endmodule