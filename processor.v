/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
    //fetch stage
    wire multdiv_in_progress, mult_div_rdy, alu_exception, stall1;
   
    wire needs_flush, decode_jr, stall;
    assign needs_flush = (take_bex | take_blt | take_bne | execute_jr);
    wire decode_branch = (decode_blt | decode_bne | decode_jr);
    assign stall1 = (((FD_out[26:22] == DX_out[26:22]) & decode_branch) | (FD_out[21:17] == DX_out[26:22]) | (FD_out[16:12] == DX_out[26:22])) & execute_load_word & !decode_store_word;
    assign stall = execute_jal | stall1;

    wire f_jump = (q_imem[31:27] == 5'b00001);
    wire f_jal = (q_imem[31:27] == 5'b00011);
    wire f_jr = (q_imem[31:27] == 5'b00100);
    wire f_sw = (q_imem[31:27] == 5'b00111);

    wire[31:0] fj_extended;
    assign fj_extended[26:0] = q_imem[26:0]; 
    assign fj_extended[31:27] = 5'b00000;
    wire[31:0] f_j_signed_immediate = execute_jr ? JRB_after_bypass : fj_extended;
    
    //define the PC and logic first
    wire PC_ovf, is_jump, jr_haz;
    wire [31:0] PC_plus_one, program_counter, final_address, branch_address;
    assign is_jump = (f_jump | f_jal | execute_jr) ? 1'b1 : 1'b0;
    assign jr_haz = execute_jr & ((FD_out[26:22]==XM_out[26:22]) | (FD_out[26:22]==MW_in[26:22])); //check for jr RAW hazard
    

    CLA_32 pc_addition(PC_plus_one, PC_ovf, address_imem, 32'd1, 1'b0); //add one to pc
    assign program_counter = is_jump ? f_j_signed_immediate : PC_plus_one; //change to ? statement when we have branching
    assign branch_address = (take_blt | take_bne) ? out_branch_add : program_counter;
    assign final_address = take_bex ? bex_target : branch_address;

    dffe_ref PC[31:0](address_imem, final_address, !clock, (!multdiv_in_progress &  !stall), reset); //enable set to one for now FIX LATER
	
    
    wire [63:0] FD_out, FD_in;
    wire [31:0] alu_out;
    wire not_equal, alu_ovf, a_ilt_b;
    assign FD_in[63:32] = address_imem; //upper 32 of FD latch is the pc counter
    assign FD_in[31:0] =  q_imem;        //Lower 32 of FD latch is opcode 

    dffe_ref FD[63:0](FD_out, needs_flush ? 64'd0 : FD_in, !clock, (!multdiv_in_progress & !stall), reset); //Set my enable to one for now, fix later
    
    //BEGIN DECODE STAGE
    //alu and addi
    wire decode_alu_op = (FD_out[31:27] == 5'b00000);  //if first 5 of opcode all 0, we know its an alu op
    wire decode_addi = (FD_out[31:27] == 5'b00101);

    //load store
    wire decode_load_word = (FD_out[31:27] == 5'b01000);
    wire decode_store_word = (FD_out[31:27] == 5'b00111);

    //jumps
    wire decode_jump = (FD_out[31:27] == 5'b00001);
    assign decode_jr = (FD_out[31:27] == 5'b00100);
    wire decode_jal = (FD_out[31:27] == 5'b00011);

    wire decode_bex = (FD_out[31:27] == 5'b10110);
    wire decode_bne = (FD_out[31:27] == 5'b00010); 
    wire decode_blt = (FD_out[31:27] == 5'b00110);

    assign ctrl_readRegA = FD_out[21:17]; // rs to crtl_readRegA, no harm if we don't use 
    assign ctrl_readRegB = decode_bex ? rstatus : (decode_alu_op ? FD_out[16:12] : FD_out[26:22]); //if r-type B is rt, if not B is rd

    wire [127:0] DX_out, DX_in;
    assign DX_in[127:96] = data_readRegA; // upper 32 of DX latch DATA REG A
    assign DX_in[95:64] = data_readRegB;  // next 32 of DX latch DATA REG B
    assign DX_in[63:32] = FD_out[63:32];  // next 32 of DX is the PC counter
    assign DX_in[31:0] =  FD_out[31:0];    // Lower 32 of DX latch is still opcode 

    dffe_ref DX[127:0](DX_out, (stall | needs_flush) ? 128'd0 : DX_in, !clock, !multdiv_in_progress || mult_div_rdy, reset); //Set my enable to one for now, fix later
    
    //BEGIN EXECUTE STAGE

    //alu and addi
    wire execute_alu_op = (DX_out[31:27] == 5'b00000);  //if first 5 of opcode all 0, we know its an alu op
    wire execute_addi = (DX_out[31:27] == 5'b00101);

    wire mult_alu_op =(DX_out[6:2] == 5'b00110);
    wire div_alu_op = (DX_out[6:2] == 5'b00111);

    //load store
    wire execute_load_word = (DX_out[31:27] == 5'b01000);
    wire execute_store_word = (DX_out[31:27] == 5'b00111);

    wire execute_i_type = (execute_load_word | execute_addi | execute_store_word | execute_blt | execute_bne);
    //jumps
    wire execute_jal = (DX_out[31:27] == 5'b00011);
    wire execute_jr = (DX_out[31:27] == 5'b00100);
    wire execute_bne = (DX_out[31:27] == 5'b00010);
    wire execute_blt = (DX_out[31:27] == 5'b00110);
    wire execute_bex = (DX_out[31:27] == 5'b10110);
    
    wire is_mult;
    wire is_div;
    assign is_mult = execute_alu_op &&  mult_alu_op && !multdiv_in_progress;
    assign is_div = execute_alu_op && div_alu_op && !multdiv_in_progress;

    wire[31:0] bex_target;
    assign bex_target[26:0] = DX_out[26:0]; // Grab i type immediate from DX 
    assign bex_target[31:27] = 5'b00000;

    wire out_branch_ovf, mult_div_exception;
    wire [31:0] i_signed_immediate, out_branch_add, mult_div_res;
    assign i_signed_immediate[16:0] = DX_out[16:0]; // Grab i type immediate from DX 
    assign i_signed_immediate[31:17] = DX_out[16] ? 15'b111111111111111: 15'b000000000000000; // Sign extend it to fit the full 32-bits

    CLA_32 branchAdd(out_branch_add, out_branch_ovf, i_signed_immediate, DX_out[63:32], 1'b1); //calculate the pc +1+n if there is a branch
   
    wire [31:0] into_alu_B, alu_ex_data, exception_data;
    assign into_alu_B = (execute_alu_op | execute_blt | execute_bne | execute_bex) ? DX_out[95:64] : i_signed_immediate;

    wire i_alu_op, is_alu_exception;
    assign i_alu_op = (execute_blt | execute_bne | execute_bex) ? 5'b00001 : 5'b00000;

    //bypassing logic
    wire potential_hazard, XM_uses_rd, MW_uses_rd, DX_uses_rs, rs_zero, rt_zero;
    wire [1:0] A_select, B_select, JRB_select;
    wire [31:0] A_after_bypass, B_after_bypass, JRB_after_bypass;
    assign XM_uses_rd = memory_alu_op | memory_addi | memory_lw | memory_setx | memory_jal; //make sure we only bypass when necessary
    assign DX_uses_rs = execute_alu_op | execute_addi | execute_load_word | execute_store_word | execute_bne | execute_blt;
    assign MW_uses_rd = write_alu_op | write_addi | write_lw | write_setx | write_jal; //make sure we only bypass when necessary

    assign potential_hazard = ((execute_alu_op & (DX_out != 0)) | execute_addi | execute_load_word | execute_store_word | execute_jr | execute_blt | execute_bne); 
    assign rs_zero = &(!DX_out[21:17]); 
    assign rt_zero = &(!DX_out[16:12]); 

    assign A_select[0] = (!rs_zero & potential_hazard & XM_uses_rd) & ((XM_out[26:22] == DX_out[21:17]) | (XM_out[128] & (rstatus == DX_out[21:17]))); // if rs DX = rd XM   
    assign A_select[1] = (!rs_zero & potential_hazard & MW_uses_rd) & ((MW_out[26:22] == DX_out[21:17]) | (MW_out[128] & (rstatus == DX_out[21:17]))); // if rs DX = rd MW

    assign B_select[0] = (!rt_zero & potential_hazard & XM_uses_rd) & ((XM_out[26:22] == DX_out[16:12]) | (XM_out[128] & (rstatus == DX_out[16:12]))); // if rt DX = rd XM
    assign B_select[1] = (!rt_zero & potential_hazard & MW_uses_rd) & ((MW_out[26:22] == DX_out[16:12]) | (MW_out[128] & (rstatus == MW_out[16:12]))); // if rt DX = rd MW

    assign JRB_select[0] = (potential_hazard & XM_uses_rd) & (XM_out[26:22] == DX_out[26:22]); // if rd DX = rd XM
    assign JRB_select[1] = (potential_hazard & MW_uses_rd) & (MW_out[26:22] == DX_out[26:22]); // if rd DX = rd MW
    
    
   
    mux_4 A(A_after_bypass, A_select, DX_out[127:96], XM_out[95:64], data_writeReg ,XM_out[95:64]); 
    mux_4 B(B_after_bypass, B_select, into_alu_B, XM_out[95:64], data_writeReg , XM_out[95:64]); 
    mux_4 JR(JRB_after_bypass, JRB_select, DX_out[95:64], XM_out[95:64], data_writeReg ,XM_out[95:64]);
    
    //changes
    
   

    alu actual_alu(execute_bex ? 32'd0 : A_after_bypass, (execute_bne | execute_blt) ? JRB_after_bypass: B_after_bypass, (execute_i_type ? i_alu_op : DX_out[6:2]), DX_out[11:7], alu_out, not_equal, a_ilt_b, alu_ovf);
    dffe_ref multdiv_latch(multdiv_in_progress, (is_mult | is_div), clock, is_mult | is_div | mult_div_rdy, reset);
    multdiv mult_div(A_after_bypass, B_after_bypass, is_mult, is_div, clock, mult_div_res, mult_div_exception, mult_div_rdy);


    mux_8 exception_choose(alu_ex_data, DX_out[4:2], 32'd1, 32'd3, 32'd0, 32'd0, 32'd0, 32'd0, 32'd4, 32'd5);
    assign exception_data = execute_addi ? 32'd2 : alu_ex_data;
    assign is_alu_exception = ((execute_alu_op | execute_addi ) & (alu_ovf | (mult_alu_op && multdiv_in_progress && mult_div_exception) | (div_alu_op && multdiv_in_progress && mult_div_exception)));

    wire take_bne, take_blt, take_bex, b_ilt_a;
    assign b_ilt_a = !a_ilt_b;
    assign take_bne = (execute_bne & not_equal) ? 1'b1 : 1'b0;
    assign take_blt = (execute_blt & b_ilt_a & not_equal) ? 1'b1 : 1'b0;
    assign take_bex = (execute_bex & not_equal) ? 1'b1 : 1'b0;
    
    wire [128:0] XM_out, XM_in;
    assign XM_in[127:96] = DX_out[63:32]; // upper 32 is pc counter
    assign XM_in[95:64] = is_alu_exception ? exception_data : ((multdiv_in_progress & mult_div_rdy) ? mult_div_res : alu_out);  // next 32 of XM is output ALU
    assign XM_in[63:32] = DX_out[95:64];  // next 32 of XM read reg b
    assign XM_in[31:0] = DX_out[31:0];    // Lower 32 of XM latch is opcode still may need to change
    assign XM_in[128] = is_alu_exception; //carries exception

    dffe_ref XM[128:0](XM_out, XM_in, !clock, !multdiv_in_progress || mult_div_rdy, reset); //Set my enable to one for now, fix later
    
    //BEGIN MEMORY STAGE

    // aly 
    wire memory_alu_op = (XM_out[31:27] == 5'b00000);
    wire memory_addi = (XM_out[31:27] == 5'b00101);
    
    //load and store
    wire memory_lw = (XM_out[31:27] == 5'b01000);
    wire memory_sw = (XM_out[31:27] == 5'b00111);
    
    //jal
    wire memory_jal = (XM_out[31:27] == 5'b00011);
    wire memory_jr = (XM_out[31:27] == 5'b00100);
    wire memory_setx = (XM_out[31:27] == 5'b10101);

    //handle memory bypass
    wire mw_haz, to_mem_select, from_mem_select, mw_haz_select;
    assign mw_haz = memory_sw;

    assign mw_haz_select = mw_haz & MW_uses_rd & ((write_jal & (XM_out[26:22] == 5'b11111)) | ((XM_out[26:22] == MW_out[26:22]))); // | (5'd31 == MW_out[26:22])



    // only enable writes for store-word instructions
    assign wren = memory_sw ? 1'b1 : 1'b0;
    assign data = mw_haz_select ? data_writeReg : XM_out[63:32]; ///if not hazard, im wiritng B to memory-- if not high need to grab whats in rd 
    assign address_dmem = XM_out[95:64];

    wire [128:0] MW_out, MW_in;
    assign MW_in[127:96] = XM_out[127:96]; // upper 32 is pc counter
    assign MW_in[95:64] = XM_out[95:64];  // next 32 of MW is output ALU
    assign MW_in[63:32] = q_dmem;  // the data we got from dmem
    assign MW_in[31:0] = XM_out[31:0];    // Lower 32 of MW latch is opcode still may need to change
    assign MW_in[128] =  XM_out[128]; //exception carries in

    dffe_ref MW[128:0](MW_out, MW_in, !clock, !multdiv_in_progress || mult_div_rdy, reset); //Set my enable to one for now, fix later
    //alu ops
    wire write_alu_op = (MW_out[31:27] == 5'b00000);
    wire write_addi = (MW_out[31:27] == 5'b00101);

    //load
    wire write_lw =  (MW_out[31:27] == 5'b01000);

    //jal
    wire write_jal = (MW_out[31:27] == 5'b00011);

    wire write_setx = (MW_out[31:27] == 5'b10101);
   
    // ctrl_writeReg for r-type, addi, and LW is rd
    // ctrl_writeReg for jal is r31
    // ctrl_writeReg for setx is r30 (rstatus)
    wire[31:0] setx_immediate;
    assign setx_immediate[26:0] = MW_out[26:0]; // Grab i type immediate from DX 
    assign setx_immediate[31:27] = 5'b00000; // Sign extend it to fit the full 32-bits


    wire [31:0] alu_op_write, jal_plus_one;
    wire[4:0] jal_reg = write_jal ? 5'd31 : 5'b00000;
    wire JAL_ovf;
    wire[4:0] rstatus = 5'b11110;
    
    CLA_32 jal_addition(jal_plus_one, JAL_ovf, MW_out[127:96], 32'd1, 1'b0);

    assign ctrl_writeReg = (write_setx | MW_out[128]) ? rstatus : (write_jal ? jal_reg : MW_out[26:22]);   
    assign alu_op_write = (write_alu_op | write_addi) ? MW_out[95:64]: MW_out[63:32];  
    assign data_writeReg = write_setx ? setx_immediate : (write_jal ? jal_plus_one : alu_op_write);  

    assign ctrl_writeEnable = (write_setx | write_jal | write_alu_op | write_lw | write_addi) ? 1'b1 : 1'b0;

    /* END CODE */

endmodule
