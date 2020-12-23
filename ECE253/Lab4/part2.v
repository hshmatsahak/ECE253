module part2 (SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	// switches
	input [9:0] SW; 
	input [3:0] KEY;
	output [9:0] LEDR;
	
	// regout = aluout at positive clock edge, LEDR = register output
	reg [7:0] ALUout;
	wire [7:0] REGout;
	pos_edge_triggered_FF FF(.Clock(~KEY[0]), .Reset_b(SW[9]), .d(ALUout), .q(REGout));
	assign LEDR[7:0] = REGout;
	
	// inputs
	wire [3:0] Data, B;
	assign Data = SW[3:0];
	assign B = REGout[3:0]; 
	
	// instantiate six seven-segment displays
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	
	// cannot instantiate adder inside always block, so do it here
	wire [9:0] w0; 
	ripple_carry_adder adder({1'b0, Data, B}, w0); // w0 stores value that should be displayed if ~KEy=3'b000
	
	// seven segment display for input(SW) and output
	hex Data_hex(Data, HEX0);
	hex h4(REGout[3:0], HEX4); // least significant bits of register
	hex h5(REGout[7:4], HEX5); // most significant bits of register
	
	// hex1, hex2, hex3 0 always
	assign HEX1[6] = 1;
	assign HEX2[6] = 1;
	assign HEX3[6] = 1;
	
	// always block to control LEDR(ALUout) 
	always @(*)
	begin
		case(~KEY[3:1]) // avoid trap
			// A+B using adder form Part 2 of lab
			3'b000: ALUout = {3'b000, w0[9], w0[3:0]};
		
			// A+B using Verilog + operator
			3'b001: ALUout = Data + B;
			
			// Sign extension of B to 8 bits
			3'b010: 
				if (B[3]==1) 
					ALUout = {4'b1111, B[3:0]};
				else
					ALUout = {4'b0000, B[3:0]};
					
			// Output 8'b00000001 if at least 1 of the 8 bits in the two inputs is 1 using a single OR operation
			3'b011: ALUout = |{Data, B}; 
			
			//Output 8'b00000001 if all of the 8 bits in the two inputs are 1 using a single AND operation
			3'b100: ALUout = &{Data, B};
			
			// Left shift A by B bits
			3'b101: ALUout = Data << B;
			
			// A x B using * operator
			3'b110: ALUout = Data*B;
			
			// Hold current value in the Register; ie register value doesn't change
			3'b111: ALUout = REGout;
			
			// default case: set output to zero
			default: ALUout = 8'b00000000;
		endcase
	end
endmodule	

module pos_edge_triggered_FF(Clock, Reset_b, d, q);
	input Clock, Reset_b;
	input [7:0] d;
	output reg [7:0] q;
	always @(posedge Clock)
	begin
		if (Reset_b == 1'b0)
			q <= 8'b00000000; // <= used for flip flops, called nonblocking statement
		else 
			q <= d;
	end
endmodule
	

// copy part2 module
module ripple_carry_adder(SW, LEDR);
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
	assign HEX0[3] = ((!c3)&(!c2)&(!c1)&(c0)) | ((!c3)&(c2)&(!c1)&(!c0)) | ((!c3)&(c2)&(c1)&(c0)) | ((c3)&(!c2)&(c1)&(!c0)) | ((c3)&(c2)&(c1)&(c0));
	assign HEX0[4] = ((!c3)&(!c2)&(!c1)&(c0)) | ((!c3)&(!c2)&(c1)&(c0)) | ((!c3)&(c2)&(!c1)&(!c0)) | ((!c3)&(c2)&(!c1)&(c0)) | ((!c3)&(c2)&(c1)&(c0)) | ((c3)&(!c2)&(!c1)&(c0));
	assign HEX0[5] = ((!c3)&(!c2)&(!c1)&(c0)) | ((!c3)&(!c2)&(c1)&(!c0)) | ((!c3)&(!c2)&(c1)&(c0)) | ((!c3)&(c2)&(c1)&(c0)) | ((c3)&(c2)&(!c1)&(c0));
	assign HEX0[6] = ((!c3)&(!c2)&(!c1)&(!c0)) | ((!c3)&(!c2)&(!c1)&(c0)) | ((!c3)&(c2)&(c1)&(c0)) | ((c3)&(c2)&(!c1)&(!c0));
endmodule

