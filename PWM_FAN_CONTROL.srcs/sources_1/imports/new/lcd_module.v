`timescale 1ns / 1ps

module LCD_Module(
	clk,
	lcd_rs,
	lcd_rw,
	lcd_e,
	lcd_7,
	lcd_6,
	lcd_5,
	lcd_4,
	lcd_3,
	lcd_2,
	lcd_1,
	lcd_0,
	dig3,
	dig4,
	dig5,
	dig6,
	sw
	
    );

	input wire clk;
	
	//LCD outputs
    output reg lcd_rs;
    output reg lcd_rw;
    output reg lcd_e;
    output reg lcd_7;
    output reg lcd_6;
    output reg lcd_5;
    output reg lcd_4;
    output reg lcd_3;
    output reg lcd_2;
    output reg lcd_1;
    output reg lcd_0;
    
    //digits to be displayed on LCD
    input [3:0] dig3;
    input [3:0] dig4;
    input [3:0] dig5;
    input [3:0] dig6;
    
    //variable to detect if LCD shows temp or RPM
    input sw;
	
	//Regs to hold alternatate display values
	reg [9:0] mode0;
	reg [9:0] mode1;
	reg [9:0] mode2;
	reg [9:0] modeop0;
	reg [9:0] modeop1;
	
	//Reg for binary to LCD
	reg [9:0] tach0;
	reg [9:0] tach1;
	reg [9:0] tach2;
	reg [9:0] tach3;
	
	//convert from reg to display
	always @(dig3)
		begin
			case(dig3)
				4'h0 : tach0 = 10'b1000110000; //0
                4'h1 : tach0 = 10'b1000110001; //1
                4'h2 : tach0 = 10'b1000110010; //2
                4'h3 : tach0 = 10'b1000110011; //3
                4'h4 : tach0 = 10'b1000110100; //4
                4'h5 : tach0 = 10'b1000110101; //5
                4'h6 : tach0 = 10'b1000110110; //6
                4'h7 : tach0 = 10'b1000110111; //7
                4'h8 : tach0 = 10'b1000111000; //8
                4'h9 : tach0 = 10'b1000111001; //9
			 default : tach0 = 10'b1000100000; // blank
			 endcase
		end

	always @(dig4)
		begin
			case(dig4)
				4'h0 : tach1 = 10'b1000110000; //0
				4'h1 : tach1 = 10'b1000110001; //1
				4'h2 : tach1 = 10'b1000110010; //2
				4'h3 : tach1 = 10'b1000110011; //3
				4'h4 : tach1 = 10'b1000110100; //4
				4'h5 : tach1 = 10'b1000110101; //5
				4'h6 : tach1 = 10'b1000110110; //6
				4'h7 : tach1 = 10'b1000110111; //7
				4'h8 : tach1 = 10'b1000111000; //8
				4'h9 : tach1 = 10'b1000111001; //9
			 default : tach1 = 10'b1000100000; // blank
			 endcase
		end 

	always @(dig5)
		begin
			case(dig5)
				4'h0 : tach2 = 10'b1000110000; //0
				4'h1 : tach2 = 10'b1000110001; //1
				4'h2 : tach2 = 10'b1000110010; //2
				4'h3 : tach2 = 10'b1000110011; //3
				4'h4 : tach2 = 10'b1000110100; //4
				4'h5 : tach2 = 10'b1000110101; //5
				4'h6 : tach2 = 10'b1000110110; //6
				4'h7 : tach2 = 10'b1000110111; //7
				4'h8 : tach2 = 10'b1000111000; //8
				4'h9 : tach2 = 10'b1000111001; //9
			 default : tach2 = 10'b1000100000; // blank
			 endcase
		end

	always @(dig6)
		begin
			case(dig6)
				4'h0 : tach3 = 10'b1000100000; // blank
				4'h1 : tach3 = 10'b1000110001; //1
				4'h2 : tach3 = 10'b1000110010; //2
				4'h3 : tach3 = 10'b1000110011; //3
				4'h4 : tach3 = 10'b1000110100; //4
				4'h5 : tach3 = 10'b1000110101; //5
				4'h6 : tach3 = 10'b1000110110; //6
				4'h7 : tach3 = 10'b1000110111; //7
				4'h8 : tach3 = 10'b1000111000; //8
				4'h9 : tach3 = 10'b1000111001; //9
			 default : tach3 = 10'b1000100000; // blank
			 endcase
		end
		//Check which mode display is in
		 always @(*)
             begin
               if(sw == 1)
                   begin
                    mode0 <= 10'b1001010100;    //T
                    mode1 <= 10'b1001001101;    //M
                    mode2 <= 10'b1001010000;    //P
                    modeop0 <= 10'b1011011111;  //o
                    modeop1 <= 10'b1001000011;  //C
                   end
                else
                    begin
                    mode0 <= 10'b1001010010;    //R
                    mode1 <= 10'b1001010000;    //P
                    mode2 <= 10'b1001001101;    //M
                    modeop0 <= 10'b1000100101;   //%
                    modeop1 <= 10'b1000010000;    //nothing
                   end
                
                    
             end  
		
	
	
	//lcd |RS|RW|D0-D7| 10 bits
	reg [9:0] lcd_code;
	
	//lcd plus data line
	reg [10:0] lcd_full;
	
	reg lcd_busy = 1;
	reg lcd_ste;
	
	parameter k = 17;
	reg [26:0] count=0;

	//display loop
	always @ (posedge clk)
		begin
			count <= count + 1;
			case (count[k+7:k+2])
				1: lcd_code <= 10'b0000111100; //function set
				
				2: lcd_code <= 10'b0000001100; //display on/off
				
				3: lcd_code <= 10'b0000000001; //display clear
				
				4: lcd_code <= 10'b0000000110; //entry mode set
				
				5: lcd_code <= mode0; 
				
				6: lcd_code <= mode1; 
				
				7: lcd_code <= mode2; 
				
				8: lcd_code <= 10'b1000111010; //:
				
				9: lcd_code <= tach3;
				
				10: lcd_code <= tach2;
				
				11: lcd_code <= tach1;
			
				12: lcd_code <=  10'b1000101110; //.
				
				13: lcd_code <= tach0;
				
				14: lcd_code <= modeop0;
				
				15: lcd_code <= modeop1;
								  
		    default: lcd_code <= 10'b1000100000;// read busy
			endcase
		      	
			if (lcd_rw & clk <= 67000000)
				lcd_busy <= ~lcd_busy;
				
			lcd_ste <= ^count[k+1:k+0] & ~lcd_rw & lcd_busy; //clkrate / 2^(k+2)
			lcd_full <= {lcd_ste,lcd_code};
			{lcd_e,lcd_rs,lcd_rw,lcd_7,lcd_6,lcd_5,lcd_4,lcd_3,lcd_2,lcd_1,lcd_0} <= lcd_full;
		end
	
endmodule 
