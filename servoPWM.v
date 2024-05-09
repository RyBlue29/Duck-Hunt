module servoPWM(
	clock, 
    reset,
	int_from_reg, 
	signal);
	
	input clock;
    input reset;
	input [31:0] int_from_reg;
    output signal;
    reg[31:0] counter_math = 0;

    wire[31:0] test180;
    assign test180 = 32'd180;

    reg[31:0] cycle_count = 0;
    reg[31:0] temp;
    reg sig = 0;
    wire signal;
    
    always @(posedge clock) begin
        if (reset) begin
            cycle_count <= 0;
        end 
        if (cycle_count > 2000000) begin
            cycle_count <= 0;
        end else begin
            cycle_count <= cycle_count + 1;
        end
    end
    
    always@(negedge clock)begin
        counter_math = ((100000/180) * int_from_reg) + 100000;
        if (cycle_count < counter_math) begin
            sig <= 1;
        end else begin
            sig <= 0;
        end
    end
    assign signal = sig;
endmodule