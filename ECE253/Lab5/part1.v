// Counter
module part1(SW, KEY, HEX0, HEX1);
	input [9:0] SW;
	input [3:0] KEY;

	output [6:0] HEX0, HEX1;
	
	wire [7:0] w;
	
	Tflipflop U0(.clk(KEY[0]), .D(SW[1]), .clear(SW[0]), .Q(w[0]));
	Tflipflop U1(.clk(KEY[0]), .D(w[0] & SW[1]), .clear(SW[0]), .Q(w[1]));
	Tflipflop U2(.clk(KEY[0]), .D(w[1] & w[0] & SW[1]), .clear(SW[0]), .Q(w[2]));
	Tflipflop U3(.clk(KEY[0]), .D(w[2] & w[1] & w[0] & SW[1]), .clear(SW[0]), .Q(w[3]));
	Tflipflop U4(.clk(KEY[0]), .D(w[3] & w[2] & w[1] & w[0] & SW[1]), .clear(SW[0]), .Q(w[4]));
	Tflipflop U5(.clk(KEY[0]), .D(w[4] & w[3] & w[2] & w[1] & w[0] & SW[1]), .clear(SW[0]), .Q(w[5]));
	Tflipflop U6(.clk(KEY[0]), .D(w[5] & w[4] & w[3] & w[2] & w[1] & w[0] & SW[1]), .clear(SW[0]), .Q(w[6]));
	Tflipflop U7(.clk(KEY[0]), .D(w[6] & w[5] & w[4] & w[3] & w[2] & w[1] & w[0] & SW[1]), .clear(SW[0]), .Q(w[7]));
	
	hex h0 (w[3:0], HEX0);
	hex h1 (w[7:4], HEX1);
endmodule

// T flip-flop
module Tflipflop(input clk, D, clear, output reg Q);
	always @(posedge clk)
	begin
		if (!clear)
			Q <= 0;
		else
			if (D)
				Q <= ~Q;
			else
				Q <= Q;		
	end
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
