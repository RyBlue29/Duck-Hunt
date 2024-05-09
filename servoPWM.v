module servoPWM(
	clock, 
    reset,
	int_from_reg, 
	signal);
	
	input clock;
    input reset;
	input [31:0] int_from_reg;
    output signal;


    reg [31:0] cycle_count = 0;
    
    reg sig = 0;
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            cycle_count <= 0;
        end else begin
            cycle_count <= cycle_count + 1;
        end
    end

    always @* begin
        counter_math = ((25000/180) * int_from_reg) + 25000;
        if (cycle_count < counter_math) begin
            sig = 1;
        end else begin
            sig = 0;
        end
    end

    assign signal = sig;

endmodule