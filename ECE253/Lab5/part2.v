module part2(SW, CLOCK_50, HEX0);
	input CLOCK_50;
	input [9:0] SW;
	output [6:0] HEX0;
	
	reg [27:0] speed;
	always @(*)
	begin
		case(SW[1:0])
			2'b00: speed = 'd0; 
			2'b01: speed = 'd499;
			2'b10: speed = 'd999;
			2'b11: speed = 'd1999;
		endcase
	end
	wire enable_w;
	wire [3:0] q;
	rate_divider RD(.clock(CLOCK_50), .d(speed), .clear(SW[9]), .enable(enable_w));
	display_counter DC(.reset_b(SW[9]), .clock(CLOCK_50), .enable(enable_w), .Q(q));
		
	hex h0(q[3:0], HEX0);
endmodule

module display_counter(reset_b, clock, enable, Q);
	input reset_b, clock, enable;
	output reg [3:0] Q;
	
	always @(posedge clock)
	begin
		if (reset_b)
			Q <= 0;
		else if (enable)
			Q <= Q + 1;
		else
			Q <= Q;
	end
endmodule

module rate_divider(clock, d, clear, enable);
	input clock, clear;
	input [27:0] d;
	output enable;
	
	reg [27:0] q;
	
	always @(posedge clock)
	begin
		if (clear == 1'b1) // active high
			q <= d; 
		else if (q == 0)
			q <= d;
		else
			q <= q - 1;
	end
	
	assign enable = (q == 0) ? 1:0;
endmodule

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
