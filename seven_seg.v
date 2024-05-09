module bcd_to_7seg(
    input [7:0] bcd,
    output reg [6:0] segment1,
    output reg [6:0] segment2
);

// BCD to 7-segment display truth table
//   a
// f   b
//   g
// e   c
//   d

reg [6:0] segments [0:9] = {
    7'b1111110, // 0 
    7'b0110000, // 1
    7'b1101101, // 2
    7'b1111001, // 3
    7'b0110011, // 4
    7'b1011011, // 5
    7'b0011111, // 6
    7'b1110000, // 7
    7'b1111111, // 8
    7'b1101111  // 9
};

reg [3:0] digit1, digit2;

always @(*) begin
    digit1 = bcd % 10;          // Extract the least significant digit - ones place
    digit2 = (bcd / 10) % 10;   // Extract the most significant digit - tens place
end

always @(*) begin
    segment1 = segments[digit1];
    segment2 = segments[digit2];
end

endmodule