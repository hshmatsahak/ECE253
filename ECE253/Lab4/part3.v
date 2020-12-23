module part3(SW, KEY, LEDR);
	// SW[7:0] -> Data_In[7:0]
	// SW[9] -> ACTIVE-HIGH RESET
	// KEY[0] -> clock
	// KEY[1] -> ParallelLoadn
	// KEY[2] -> RotateRight
	// KEY[3] -> ASRight
	// Outputs Q[7:0] -> LEDR[7:0]
	
	// Parallel load = 0 -> data_in stored on next clock edge
	// parallel loadd = 1, rotate_right = 1, asright = 0 -> right rotate with wrap around
	// parallel loadd = 1, rotate_right = 1, asright = 1-> right rotate, repeat msb
	// parallel load = 1, rotateright = 0 -> left with wrap
	input [9:0] SW;
	input [3:0] KEY;
	output [9:0] LEDR;
	wire [7:0] Q;
	load_instance U0(.right(Q[6]), .left((Q[0]&(KEY[3]))|(Q[7]&~KEY[3])), .D(SW[7]), .loadleft(~KEY[2]), .loadn(~KEY[1]), .clock(~KEY[0]), .reset(SW[9]), .Q(Q[7]));
	load_instance U1(.right(Q[5]), .left(Q[7]), .D(SW[6]), .loadleft(~KEY[2]), .loadn(~KEY[1]), .clock(~KEY[0]), .reset(SW[9]), .Q(Q[6]));
	load_instance U2(.right(Q[4]), .left(Q[6]), .D(SW[5]), .loadleft(~KEY[2]), .loadn(~KEY[1]), .clock(~KEY[0]), .reset(SW[9]), .Q(Q[5]));
	load_instance U3(.right(Q[3]), .left(Q[5]), .D(SW[4]), .loadleft(~KEY[2]), .loadn(~KEY[1]), .clock(~KEY[0]), .reset(SW[9]), .Q(Q[4]));
	load_instance U4(.right(Q[2]), .left(Q[4]), .D(SW[3]), .loadleft(~KEY[2]), .loadn(~KEY[1]), .clock(~KEY[0]), .reset(SW[9]), .Q(Q[3]));
	load_instance U5(.right(Q[1]), .left(Q[3]), .D(SW[2]), .loadleft(~KEY[2]), .loadn(~KEY[1]), .clock(~KEY[0]), .reset(SW[9]), .Q(Q[2]));
	load_instance U6(.right(Q[0]), .left(Q[2]), .D(SW[1]), .loadleft(~KEY[2]), .loadn(~KEY[1]), .clock(~KEY[0]), .reset(SW[9]), .Q(Q[1]));
	load_instance U7(.right(Q[7]), .left(Q[1]), .D(SW[0]), .loadleft(~KEY[2]), .loadn(~KEY[1]), .clock(~KEY[0]), .reset(SW[9]), .Q(Q[0]));
	assign LEDR[7:0] = Q[7:0];
endmodule 

module load_instance(right, left, D, loadleft, loadn, clock, reset, Q);
	input left, right, D, loadleft, loadn, clock, reset;
	output Q;
	wire rotateddata, datato_dff;
	mux2to1 M0(.x(right), .y(left), .s(loadleft), .m(rotateddata));
	mux2to1 M1(.x(D), .y(rotateddata), .s(loadn), .m(datato_dff));
	flipflop F0(.d(datato_dff), .q(Q), .clock(clock), .reset(reset));
endmodule

module mux2to1(x,y,s,m);
	input x,y,s;
	output m;
	assign m = (~s)&x | s&y;
endmodule


module flipflop(d, q, clock, reset);
	input clock, reset;
	input d;
	output reg q;
	always @(posedge clock)
	begin
		if (reset == 1'b1)
			q <= 0; 
		else 
			q <= d;
	end
endmodule







