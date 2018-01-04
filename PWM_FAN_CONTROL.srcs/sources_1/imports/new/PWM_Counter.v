`timescale 1ns / 1ps

module PWM_Counter(
	clk,
	data,
	pwm
	);
	input clk;
	input [15:0] data;
	output reg pwm;
		
	//count to 4000 for 25khz
	reg [11:0] counter = 0;
	
	always @(posedge clk)
	begin
		counter = counter + 1'b1;
		
		//Use last 4 bits of data to allow higher resolution		
		if (counter <= (data[15:12]*250)) pwm = 1;
		
		else pwm = 0;
		
		if (counter >= 4000) counter = 0;
		
	end
	
endmodule
