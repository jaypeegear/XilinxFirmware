`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:44:46 06/08/2018 
// Design Name: 
// Module Name:    counter_program 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//16'b0000000000000000
//16'b1111111111111111
module counter_program(
	input clk,
	input sig,
	input sw,
	output [15:0] quotient,
	output [15:0] fractional,
	output khz_clk,
	output hz_clk
	);
//declarations
reg [15:0] count = 16'b000000000000000;
reg [15:0] tempc = 16'b000000000000000;
reg [9:0] count2 = 10'b0000000000;
reg [9:0] tempc2 = 10'b0000000000;
reg [15:0] sample =16'b000000000000000;
reg [15:0] temple = 16'b000000000000000;
reg khz_clk = 1'b0;
reg hz_clk = 1'b0;
reg [9:0] count3 = 10'b00000000;
reg [9:0] tempc3 = 10'b00000000;

div divider (
	.clk(clk), // input clk
	.rfd(rfd), // output rfd
	.dividend(sample), // input [15 : 0] dividend
	.divisor(count), // input [15 : 0] divisor
	.quotient(quotient), // output [15 : 0] quotient
	.fractional(fractional)); // output [15 : 0] fractional



always @ (posedge sig)
begin // count or reset
	if (sw == 1)
	begin
		sample = 16'b0000000000000000;
		temple = 16'b0000000000000000;
	end
	else
	begin
		sample = sample;
		temple = temple;
	end
	if (count != 16'b1111111111111111)
	begin
		temple = sample + 1;
		sample = temple;
	end
	else
	begin
			temple = temple;
			sample = sample;
	end
	if (fractional <= 16'b000000000010000 && count == 16'b1111111111111111  && khz_clk == 1'b1 && hz_clk != 1'b1)
	begin
		sample = 16'b0000000000000000;
		temple = 16'b0000000000000000;
	end
	else
	begin
			if (fractional <= 16'b000000000010000 && count == 16'b1111111111111111 && khz_clk != 1'b1 && hz_clk == 1'b1)
		begin
			sample = 16'b0000000000000000;
			temple = 16'b0000000000000000;
		end
		else
		begin	
				if (khz_clk == 1'b1 && hz_clk == 1'b1)
				begin
					sample = 16'b0000000000000000;
					temple = 16'b0000000000000000;
				end
				else
				begin
					sample = sample;
					temple = temple;
				end
		end
	end
	
end

always @ (posedge clk)
begin//count, check if count is complete and engage dividers
	if (sw == 1)
	begin
		khz_clk = 1'b0;
		hz_clk = 1'b0;
		count = 16'b0000000000000000;
		tempc = 16'b0000000000000000;
	end
	else
	begin
		khz_clk = khz_clk;
		hz_clk = hz_clk;
		count = count;
		tempc = tempc;
	end
	if (count !=  16'b1111111111111111 && sample != 16'b1111111111111111 && sample!=16'b0000000000000000 && khz_clk != 1'b1 && hz_clk != 1'b1)
	begin
		tempc = count + 1;
		count = tempc;
	end
	else
	begin
		if (fractional <= 16'b0000000000010000 && sample!=16'b0000000000000000 && count == 16'b1111111111111111  && khz_clk != 1'b1 && hz_clk != 1'b1)
		begin
			tempc = 16'b0000000000000000;
			count = 16'b0000000000000000;
			khz_clk = 1'b1;
		end
		else
		begin
			if (fractional <= 16'b0000000000010000 && sample!=16'b0000000000000000 && count == 16'b1111111111111111  && khz_clk == 1'b1 && hz_clk != 1'b1)
			begin
				tempc = 16'b0000000000000000;
				count = 16'b0000000000000000;
				khz_clk = 1'b0;
				hz_clk = 1'b1;
			end
			else
			begin
				if (fractional <= 16'b0000000000010000 && sample!=16'b0000000000000000 && count == 16'b1111111111111111 && khz_clk != 1'b1 && hz_clk == 1'b1)
				begin
					tempc = 16'b0000000000000000;
					count = 16'b0000000000000000;
					khz_clk = 1'b1;
					hz_clk = 1'b1;
				end
				else
				begin
					tempc = tempc;
					count = count;
				end 
			end
		end	
	end
		
	
	//engage hz clk
	if (khz_clk != 1'b1 && hz_clk == 1'b1)
		begin
			if (count2 != 10'b1111101000 && sample != 16'b0000000000000000)
			begin
				tempc2 = count2 + 1;
				count2 = tempc2;
			end
			else
			begin
				tempc2 = tempc2;
				count2 = count2;
			end
			if (count2 == 10'b1111101000 && count != 16'b1111111111111111 )
			begin
				tempc2 = 10'b000000000;
				count2 = 10'b000000000;
				tempc3 = count3 + 1;
				count3 = tempc3;
				if (count3 == 10'b1111101000 && count != 16'b1111111111111111 )
				begin
					tempc3 = 10'b000000000;
					count3 = 10'b000000000;
					tempc = count + 1;
					count = tempc;
				end
				else
				begin
				tempc = tempc;
				count = count;
				tempc3 = tempc3;
				count3 = count3;
				end
			end
			else
			begin
				tempc2 = tempc2;
				count2 = count2;
				tempc = tempc;
				count = count;
			end
		end
	else
		begin
			tempc = tempc;
			count = count;
		end
	// engage khz clk
	if (khz_clk == 1'b1 && hz_clk != 1'b1)
	begin
		if (count2 != 10'b1111101000 && sample != 16'b0000000000000000)
		begin
			tempc2 = count2 + 1;
			count2 = tempc2;
		end
		else
		begin
			tempc2 = tempc2;
			count2 = count2;
		end
		if (count2 == 10'b1111101000 && count != 16'b1111111111111111)
		begin
			tempc2 = 10'b000000000;
			count2 = 10'b000000000;
			tempc = count + 1;
			count = tempc;
		end
		else
		begin
			tempc2 = tempc2;
			count2 = count2;
			tempc = tempc;
			count = count;
		end
	end
	else
	begin
		tempc = tempc;
		count = count;
	end
end

endmodule
//		if (count == 32'b00000000000000000000000000000001)
//		begin
//			tempc = 32'b00000000000000000000000000000000;
//			count = 32'b00000000000000000000000000000000;

