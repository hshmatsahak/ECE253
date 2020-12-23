module part2(SW, LEDR);	
	// input switches and output LEDs
	input [9:0] SW;
	output [9:0] LEDR;
	
	// wires for carry bits
	wire w0, w1, w2;
	
	// Ripple carry adder module = 4 full adders connected by wires w0,w1,w2
	FA A0(.cin(SW[8]), .x(SW[4]), .y(SW[0]), .co(w0), .s(LEDR[0]));
	FA A1(.cin(w0), .x(SW[5]), .y(SW[1]), .co(w1), .s(LEDR[1]));
	FA A2(.cin(w1), .x(SW[6]), .y(SW[2]), .co(w2), .s(LEDR[2]));
	FA A3(.cin(w2), .x(SW[7]), .y(SW[3]), .co(LEDR[9]), .s(LEDR[3]));
endmodule

// Full Adder module
module FA(input cin,x,y, output co,s);
	assign co = cin&x | cin&y | x&y; // carry bit
	assign s = (cin^x)^y; //sum bit
endmodule

