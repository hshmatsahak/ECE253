// 7-bit multiplexer
module part1(SW, LEDR);
	// input switches, outout LEDs
	input [9:0] SW; // data = SW[6:0], select = SW[9:7]
	output reg [9:0] LEDR; // display output on LEDR[0]
	
	// always block
	always @(*) // sensitivities: every variable 
	begin
		case(SW[9:7]) //select input
			3'b000: LEDR[0] = SW[0]; 
			3'b001: LEDR[0] = SW[1];
			3'b010: LEDR[0] = SW[2];
			3'b011: LEDR[0] = SW[3];
			3'b100: LEDR[0] = SW[4];
			3'b101: LEDR[0] = SW[5];
			3'b110: LEDR[0] = SW[6];
			default: LEDR[0] = 0; // default output = 0
		endcase
	end
endmodule
		
