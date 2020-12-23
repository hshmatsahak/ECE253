module part3 (SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	// switches
	input [9:0] SW; 
	input [2:0] KEY; 
	
	// declare output LEDS as reg, they are controlled in the always block
	output reg [9:0] LEDR; 
	
	// instantiate six seven-segment displays
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	
	// cannot instantiate adder inside always block, so do it here
	wire [9:0] w0; 
	part2 adder(SW, w0); // w0 stores value that should be displayed if ~KEy=3'b000
	
	// seven segment display for input(SW) and output
	hex Bhex(SW[3:0], HEX0);
	hex Ahex(SW[7:4], HEX2);
	hex h4(LEDR[3:0], HEX4);
	hex h5(LEDR[7:4], HEX5);
	
	// hex1 and hex3 0 always
	assign HEX1[6] = 1;
	assign HEX3[6] = 1;
	
	// always block to control LEDR(ALUout) 
	always @(*)
	begin
		case(~KEY[2:0]) // avoid trap
			// A+B using adder form Part 2 of lab
			3'b000: LEDR = {3'b000, w0[9], w0[3:0]};
		
			// A+B using Verilog + operator
			3'b001: LEDR = SW[7:4] + SW[3:0];
			
			// Sign extension of B to 8 bits
			3'b010: 
				if (SW[3]==1) 
					LEDR = {4'b1111, SW[3:0]};
				else
					LEDR = {4'b0000, SW[3:0]};
					
			// Output 8'b00000001 if at least 1 of the 8 bits in the two inputs is 1 using a single OR operation
			3'b011: LEDR = |SW[7:4]; 
			
			//Output 8'b00000001 if all of the 8 bits in the two inputs are 1 using a single AND operation
			3'b100: LEDR = &{SW[7:4], SW[3:0]};
			
			//Display A in the most signficant four bits and B in the lower four bits
			3'b101: LEDR = SW[7:0];
			
			// default case: set output to zero
			default: LEDR = 8'b00000000;
		endcase
	end
endmodule	

// copy part2 module
module part2(SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	
	wire w0, w1, w2;
	
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

// copy hex module from lab2
module hex(SW, HEX0);
	input [3:0] SW; 
	output [6:0] HEX0;
	
	wire c3 = SW[3];
	wire c2 = SW[2];
	wire c1 = SW[1];
   wire c0 = SW[0];
	
	assign HEX0[0] = ((!c3)&(!c2)&(!c1)&(c0)) | ((!c3)&(c2)&(!c1)&(!c0)) | ((c3)&(!c2)&(c1)&(c0)) | ((c3)&(c2)&(!c1)&(c0));
	assign HEX0[1] = ((!c3)&(c2)&(!c1)&(c0)) | ((!c3)&(c2)&(c1)&(!c0)) | ((c3)&(!c2)&(c1)&(c0)) | ((c3)&(c2)&(!c1)&(!c0)) | ((c3)&(c2)&(c1)&(!c0)) | ((c3)&(c2)&(c1)&(c0));
	assign HEX0[2] = ((!c3)&(!c2)&(c1)&(!c0)) | ((c3)&(c2)&(!c1)&(!c0)) | ((c3)&(c2)&(c1)&(!c0)) | ((c3)&(c2)&(c1)&(c0));
	assign HEX0[3] = ((!c3)&(!c2)&(!c1)&(c0)) | ((!c3)&(c2)&(!c1)&(!c0)) | ((!c3)&(c2)&(c1)&(c0)) | ((c3)&(!c2)&(!c1)&(c0)) | ((c3)&(!c2)&(c1)&(!c0)) | ((c3)&(c2)&(c1)&(c0));
	assign HEX0[4] = ((!c3)&(!c2)&(!c1)&(c0)) | ((!c3)&(!c2)&(c1)&(c0)) | ((!c3)&(c2)&(!c1)&(!c0)) | ((!c3)&(c2)&(!c1)&(c0)) | ((!c3)&(c2)&(c1)&(c0)) | ((c3)&(!c2)&(!c1)&(c0));
	assign HEX0[5] = ((!c3)&(!c2)&(!c1)&(c0)) | ((!c3)&(!c2)&(c1)&(!c0)) | ((!c3)&(!c2)&(c1)&(c0)) | ((!c3)&(c2)&(c1)&(c0)) | ((c3)&(c2)&(!c1)&(c0));
	assign HEX0[6] = ((!c3)&(!c2)&(!c1)&(!c0)) | ((!c3)&(!c2)&(!c1)&(c0)) | ((!c3)&(c2)&(c1)&(c0)) | ((c3)&(c2)&(!c1)&(!c0));
endmodule
