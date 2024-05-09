module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;
    wire notsum;

    wire [31:0] Bnot, sum, shiftedleft, shiftedright, anded, ored, add_sub_input, zeroes, noteqcheck;
    
    assign zeroes = 32'd0;



    //decide whether add or subtract with not gate
    notGate notg(Bnot, data_operandB);
    mux_2 add_sub_mux(add_sub_input, ctrl_ALUopcode[0], Bnot, data_operandB);
    

    // shifts:
    SLL shiftleft(shiftedleft, data_operandA, ctrl_shiftamt[4:0]);
    SRA shiftright(shiftedright, data_operandA, ctrl_shiftamt[4:0]);

    //add and sub, ilt and isnoteq
    CLA_32 add_sub(sum, overflow, data_operandA, add_sub_input, ctrl_ALUopcode[0]);
   
    not notsums(notsum, sum[31]);
    assign isLessThan = overflow ? notsum : sum[31];

    checksum check(isNotEqual, sum);

    //and / or
    andGate andg(anded, data_operandA, data_operandB);
    orGate org(ored, data_operandA, data_operandB);

    //final mux
    mux_8 final_mux(.out(data_result) , .select(ctrl_ALUopcode[2:0]), .in0(sum), .in1(sum), .in2(anded), .in3(ored), .in4(shiftedleft), .in5(shiftedright));
    
endmodule