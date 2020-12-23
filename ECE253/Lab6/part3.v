//Sw[7:0] data_in

//KEY[0] synchronous reset when pressed
//KEY[1] go signal

//LEDR displays result
//HEX0 & HEX1 also displays result

module part3(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	 input [9:0] SW;
	 input [3:0] KEY;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	 reg [3:0] quotient, remainder;
	 
	 always@(posedge CLOCK_50)
    begin: state_FFs
        if(!KEY[0])
		  begin
            quotient <= 4'b0;
				remainder <= 4'b0;
		  end
        else
        begin
				if (!KEY[1])
				begin
            quotient <= SW[7:4]/SW[3:0];
				remainder = SW[7:4]%SW[3:0];
				end
		  end
    end
	 
	 hex H0( 
        .SW(SW[3:0]),
        .HEX0(HEX0)
        );
        
    hex H2(
        .SW(SW[7:4]), 
        .HEX0(HEX2)
        );
	
	 hex H4(
        .SW(quotient), 
        .HEX0(HEX4)
        );
		  
	 hex H5(
        .SW(remainder), 
        .HEX0(HEX5)
        );
		  
	 assign HEX1[6] = 1;
	 assign HEX3[6] = 1;
	 assign LEDR[3:0] = quotient;
	 
endmodule	 /*
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire resetn;
    wire go;

    wire [3:0] quotient;
	 wire [4:0] remainder;
    assign go = ~KEY[1];
    assign resetn = KEY[0];

    wrapper u0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .data_in(SW[7:0]),
        .quotient(quotient),
		  .remainder(remainder)
    );

    hex H0(
        .SW(SW[3:0]),
        .HEX0(HEX0)
        );
        
    hex H2(
        .SW(SW[7:4]), 
        .HEX0(HEX2)
        );
	
	 hex H4(
        .SW(quotient[3:0]), 
        .HEX0(HEX4)
        );
		  
	 hex H5(
        .SW(remainder[3:0]), 
        .HEX0(HEX5)
        );
		  
	 assign HEX1[6] = 1;
	 assign HEX3[6] = 1;
	 assign LEDR[3:0] = quotient[3:0];
endmodule

module wrapper(
    input clk,
    input resetn,
    input go,
    input [7:0] data_in,
    output [3:0] quotient,
	 output [4:0] remainder
    );

    // lots of wires to connect our datapath and control
    wire ld_rdr, ld_dsr, ld_div, sum_bit, ld_r;
    wire ld_alu_out;
    wire alu_op, left_shift;

    control C0(
        .clk(clk),
        .resetn(resetn),      
        .go(go),
		  .sum_bit(sum_bit),

        .ld_alu_out(ld_alu_out),
        .ld_rdr(ld_rdr),
        .ld_dsr(ld_dsr),
        .ld_div(ld_div),
		  .left_shift(left_shift),
        .ld_r(ld_r),
        .alu_op(alu_op)
    );
	 
    datapath D0(
        .clk(clk),
        .resetn(resetn),
		  .data_in(data_in),
        .ld_alu_out(ld_alu_out), 
        .ld_div(ld_div),
        .ld_rdr(ld_rdr),
        .ld_dsr(ld_dsr),
        .left_shift(left_shift),
		  .ld_r(ld_r), 
		  .alu_op(alu_op),
		  
		  .sum_bit(sum_bit),		  
        .quotient(quotient),
		  .remainder(remainder)
    );                
endmodule        
                
module control(
    input clk,
    input resetn,
    input go,
	 input sum_bit,

    output reg  ld_rdr, ld_dsr, ld_div, left_shift, ld_r,
    output reg  ld_alu_out,
    output reg alu_op
    );
	
    reg [5:0] current_state, next_state; 
    
    localparam  S_LOAD             = 5'd0,
                S_LOAD_WAIT        = 5'd1,
					 
                S_SHIFTLEFT11      = 5'd2,
                S_SUBTRACT1        = 5'd3,
                S_SUBTRACT_STORE1  = 5'd4,
	 			 	 S_ADD1             = 5'd5,	 			 	 
					 S_SHIFTLEFT21 	  = 5'd6,
					 
				 	 S_SHIFTLEFT12      = 5'd7,
                S_SUBTRACT2        = 5'd8,
                S_SUBTRACT_STORE2  = 5'd9,
	 			 	 S_ADD2             = 5'd10,	 			 	 
					 S_SHIFTLEFT22 	  = 5'd11,
					 
				  	 S_SHIFTLEFT13      = 5'd12,
                S_SUBTRACT3        = 5'd13,
                S_SUBTRACT_STORE3  = 5'd14,
	 				 S_ADD3             = 5'd15,	 				 
					 S_SHIFTLEFT23 	  = 5'd16,
					 
					 S_SHIFTLEFT14      = 5'd17,
                S_SUBTRACT4        = 5'd18,
                S_SUBTRACT_STORE4  = 5'd19,
	 				 S_ADD4             = 5'd20,
	 				 S_SHIFTLEFT24 	  = 5'd21;
    
    // Next state logic aka our state table
    always @(*)
    begin: state_table 
        case (current_state)
            S_LOAD: next_state = go ? S_LOAD_WAIT : S_LOAD; // Loop in current state until value is input
            S_LOAD_WAIT: next_state = go ? S_LOAD_WAIT : S_SHIFTLEFT11; // Loop in current state until go signal goes low
            
				S_SHIFTLEFT11: next_state = S_SUBTRACT1;
            S_SUBTRACT1: next_state = S_SUBTRACT_STORE1;
            S_SUBTRACT_STORE1: next_state = sum_bit ? S_ADD1 : S_SHIFTLEFT21;
            S_ADD1: next_state = S_SHIFTLEFT21;
				S_SHIFTLEFT21: next_state = S_SHIFTLEFT12;
		
				S_SHIFTLEFT12: next_state = S_SUBTRACT2;
            S_SUBTRACT2: next_state = S_SUBTRACT_STORE2;
            S_SUBTRACT_STORE2: next_state = sum_bit ? S_ADD2 : S_SHIFTLEFT22;
            S_ADD2: next_state = S_SHIFTLEFT22;
				S_SHIFTLEFT22: next_state = S_SHIFTLEFT13;
				
				S_SHIFTLEFT13: next_state = S_SUBTRACT3;
            S_SUBTRACT3: next_state = S_SUBTRACT_STORE3;
            S_SUBTRACT_STORE3: next_state = sum_bit ? S_ADD3 : S_SHIFTLEFT23;
            S_ADD3: next_state = S_SHIFTLEFT23;
				S_SHIFTLEFT23: next_state = S_SHIFTLEFT14;
				
				S_SHIFTLEFT14: next_state = S_SUBTRACT4;
            S_SUBTRACT4: next_state = S_SUBTRACT_STORE4;
            S_SUBTRACT_STORE4: next_state = sum_bit ? S_ADD4 : S_SHIFTLEFT24;
            S_ADD4: next_state = S_SHIFTLEFT24;
				S_SHIFTLEFT24: next_state = S_LOAD;
        default: next_state = S_LOAD;
        endcase
    end // state_table

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_alu_out = 1'b0;
        ld_rdr = 1'b0;
		  ld_dsr = 1'b0;
		  ld_div = 1'b0;
		  ld_r = 1'b0;
		  left_shift = 1'b0;
        alu_op = 1'b0;

        case (current_state)
            S_LOAD: begin
                ld_rdr = 1'b1;
					 ld_dsr = 1'b1;
					 ld_div = 1'b1;
            end
            S_SHIFTLEFT11: begin // shift left
					 ld_rdr = 1'b1; 
					 left_shift = 1'b1; 
            end
				S_SHIFTLEFT21: begin // shift left
					 ld_div = 1'b1; 
					 left_shift = 1'b1; 
            end
            S_SUBTRACT1: begin // Do A <- Ax^2
                ld_alu_out = 1'b1; ld_rdr = 1'b1; // store result into A
                alu_op = 1'b1; // Do multiply operation
            end
            S_SUBTRACT_STORE1: begin // Do B <- Bx
                ld_r = 1'b1;
            end
				S_ADD1: begin // Do A <- Ax^2+Bx
                ld_alu_out = 1'b1; ld_rdr = 1'b1; // store result into A
					 alu_op = 1'b0;
            end
				
				S_SHIFTLEFT12: begin // shift left
					 ld_rdr = 1'b1; 
					 left_shift = 1'b1; 
            end
				S_SHIFTLEFT22: begin // shift left
					 ld_div = 1'b1; 
					 left_shift = 1'b1; 
            end
            S_SUBTRACT2: begin // Do A <- Ax^2
                ld_alu_out = 1'b1; ld_rdr = 1'b1; // store result into A
                alu_op = 1'b1; // Do multiply operation
            end
            S_SUBTRACT_STORE2: begin // Do B <- Bx
                ld_r = 1'b1;
            end
				S_ADD2: begin // Do A <- Ax^2+Bx
                ld_alu_out = 1'b1; ld_rdr = 1'b1; // store result into A
					 alu_op = 1'b0;
            end
				
				S_SHIFTLEFT13: begin // shift left
					 ld_rdr = 1'b1; 
					 left_shift = 1'b1; 
            end
				S_SHIFTLEFT23: begin // shift left
					 ld_div = 1'b1; 
					 left_shift = 1'b1; 
            end
            S_SUBTRACT3: begin // Do A <- Ax^2
                ld_alu_out = 1'b1; ld_rdr = 1'b1; // store result into A
                alu_op = 1'b1; // Do multiply operation
            end
            S_SUBTRACT_STORE3: begin // Do B <- Bx
                ld_r = 1'b1;
            end
				S_ADD3: begin // Do A <- Ax^2+Bx
                ld_alu_out = 1'b1; ld_rdr = 1'b1; // store result into A
					 alu_op = 1'b0;
            end
				
				S_SHIFTLEFT14: begin // shift left
					 ld_rdr = 1'b1; 
					 left_shift = 1'b1; 
            end
				S_SHIFTLEFT24: begin // shift left
					 ld_div = 1'b1; 
					 left_shift = 1'b1; 
            end
            S_SUBTRACT4: begin // Do A <- Ax^2
                ld_alu_out = 1'b1; ld_rdr = 1'b1; // store result into A
                alu_op = 1'b1; // Do multiply operation
            end
            S_SUBTRACT_STORE4: begin // Do B <- Bx
                ld_r = 1'b1;
            end
				S_ADD4: begin // Do A <- Ax^2+Bx
                ld_alu_out = 1'b1; ld_rdr = 1'b1; // store result into A
					 alu_op = 1'b0;
            end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
    input resetn,
    input [7:0] data_in,
    input ld_alu_out,
    input ld_div, ld_dsr, ld_rdr, left_shift,
    input ld_r,
    input alu_op,
	 
	 output sum_bit,
    output [3:0] quotient,
	 output [4:0] remainder
    );
    
    // input registers
    reg [3:0] div;
	 reg [4:0] dsr, rdr;

    // output of the alu
    reg [4:0] alu_out;
	 reg [4:0] data_result;
    
    // Registers a, b, c, x with respective input logic
    always @(posedge clk) 
	 begin
        if(!resetn) begin
            div <= 4'b0; 
            dsr <= 5'b0; 
            rdr <= 5'b0; 
        end
        else begin
            if(ld_dsr)
                dsr <= data_in[3:0]; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_rdr)
				begin
                if (left_shift)
						rdr <= (rdr << 1) + div[3];
					 else
						rdr <= ld_alu_out ? alu_out : 5'b0; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            end
				if(ld_div)
                div <= left_shift ? ((div << 1) + ~data_result[4]) : data_in[7:4];
        end
    end
 
    // Output result register
    always@(posedge clk) begin
        if(!resetn) begin
            data_result <= 5'b0; 
        end
        else 
            if(ld_r)
                data_result <= alu_out;
    end

    // The ALU 
    always @(*)
    begin : ALU
        // alu<
        case (alu_op)
            0: begin
                   alu_out = rdr + dsr; //performs addition
               end
            1: begin
                   alu_out = rdr - dsr; //performs multiplication
               end
            default: alu_out = 5'b0;
        endcase
    end
	 
	 assign sum_bit = data_result[4];
	 assign quotient = div;
	 assign remainder = rdr;
endmodule
*/
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
