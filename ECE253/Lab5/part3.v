module part3 (SW, KEY, LEDR, CLOCK_50);
	input [9:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	output [9:0] LEDR;
	
	wire [11:0] letter;
	letterdetector ld(.SW(SW), .result(letter));
	
	wire enablew;
	clk_divider cd(.clock(CLOCK_50), .d(249), .clear(KEY[0]), .set(KEY[1]), .enable(enablew));
	
	wire [11:0] out;
	shiftregister SR(.clock(CLOCK_50), .resetn(KEY[0]), .q(out), .enable(enablew), .loadn(KEY[1]), .d(letter));
	
	assign LEDR[0] = out[0];
endmodule

module clk_divider(clock, d, clear, set, enable);
	input clock, clear, set;
	input [10:0] d;
	output enable;
	
	reg [10:0] q;
	
	always @(posedge set, negedge clear)
		q <= d;
	
	always @(posedge clock)
	begin 
		if (q == 0)
			q <= d;
		else
			q <= q - 1;
	end
	
	assign enable = (q == 0) ? 1:0;
endmodule

module letterdetector(SW, result);
	input [9:0] SW;
	output reg [11:0] result;
	always @(*)
	begin
		case (SW[2:0])
            3'b000: result = 12'b000000111010; // A
            3'b001: result = 12'b001010101110; // B
            3'b010: result = 12'b101110101110; // C 
            3'b011: result = 12'b000010101110; // D 
            3'b100: result = 12'b000000000010; // E
            3'b101: result = 12'b001011101010; // F 
            3'b110: result = 12'b001011101110; // G
            3'b111: result = 12'b000010101010; // H
            default: result = 12'b000000000000;
        endcase
	end
endmodule

module shiftregister(clock, resetn, q, enable, loadn, d);
	input clock, resetn, enable, loadn;
	input [11:0] d;
	output reg [11:0] q;
	
	always @(posedge loadn)
		q <= d;
	
	always @(negedge resetn)
		q <= 0;

	always @(posedge clock, negedge resetn)
	begin
			//if (resetn ==1'b0)
			//	q <= 0;
			if (enable)
				begin
					q[10:0] <= q[11:1];
					q[11] <= 0;
				end
			else
				q <= q;
	end
endmodule
