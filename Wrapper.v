`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (
	
    input clk_50mhz, 
    input BTNU,
    input DOWN_signal,
    input UP_signal,
    input RIGHT_signal,
    input LEFT_signal,
    input [15:0] SW,
    input start_sig,
    input tl_PT,
    input tr_PT,
    input bl_PT,
    input br_PT,
    output [15:0] LED,
    output SERVO_testSignal,
    output up_down_output,
    output A1_display,
    output B1_display,
    output C1_display,
    output D1_display,
    output E1_display,
    output F1_display,
    output G1_display,
    output A2_display,
    output B2_display,
    output C2_display,
    output D2_display,
    output E2_display,
    output F2_display,
    output G2_display,
    output tl_l,
    output tr_l,
    output bl_l,
    output br_l);
    
    wire clock, reset, start_sig;
    assign clock = clk_50mhz;
    assign reset = BTNU;
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
	wire[31:0] reg1_servo, reg2_servo, score_reg, reg_seven;
	wire[6:0] seg1, seg2;
	
    bcd_to_7seg score(.bcd(score_reg), .segment1(seg1), .segment2(seg2)); //change .bcd to score reg once that logic is fixed
    servoPWM pwm_up_down(.clock(clock), .reset(reset), .int_from_reg(reg1_servo), .signal(up_down_output));
    servoPWM pwm_left_right(.clock(clock), .reset(reset), .int_from_reg(reg2_servo), .signal(SERVO_testSignal));
    
    assign LED[0] = SERVO_testSignal;
    assign LED[1] = !DOWN_signal;
    assign LED[2] = !UP_signal;
    assign LED[3] = !RIGHT_signal;
    assign LED[4] = !LEFT_signal;
    assign LED[5] = !start_sig;
    
    assign A1_display = seg1[6];
    assign B1_display = seg1[5];
    assign C1_display = seg1[4];
    assign D1_display = seg1[3];
    assign E1_display = seg1[2];
    assign F1_display = seg1[1];
    assign G1_display = seg1[0];
    
    assign A2_display = seg2[6];
    assign B2_display = seg2[5];
    assign C2_display = seg2[4];
    assign D2_display = seg2[3];
    assign E2_display = seg2[2];
    assign F2_display = seg2[1];
    assign G2_display = seg2[0];
    
   
        
      

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "shooter";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut));
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
		.up_down_int(reg1_servo), .left_right_int(reg2_servo), .score(score_reg), .seven(reg_seven));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut),
		.up_sig(!UP_signal),
		.down_sig(!DOWN_signal),
		.right_sig(!RIGHT_signal),
		.left_sig(!LEFT_signal),
		.start_game(!start_sig),
		.mem_check(LED[15]),
		.top_left_LED(tl_l),
		.top_right_LED(tr_l),
		.bottom_left_LED(bl_l),
		.bottom_right_LED(br_l),
		.top_left_PT(tl_PT),
		.top_right_PT(tr_PT),
		.bottom_left_PT(bl_PT),
		.bottom_right_PT(br_PT));

endmodule
