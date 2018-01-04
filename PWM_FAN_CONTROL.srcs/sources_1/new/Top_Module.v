`timescale 1ns / 1ps

module Top_Module(
   input clk,				//clk input
   input vauxp6,			//voltage diff for potentiometer
   input vauxn6,
   input vauxp7,			//voltage diff for LM35
   input vauxn7,
   input sw,				//switch to switch between inputs  
   output reg [15:0] LED,	//use LEDS to show adc output
   output pwm,				//PWM output to fan
   
   output lcd_rs,           //1602 lcd control
   output lcd_rw,
   output lcd_e,
   output lcd_7,
   output lcd_6,
   output lcd_5,
   output lcd_4,
   output lcd_3,
   output lcd_2,
   output lcd_1,
   output lcd_0    
 );

	//wires for adc
	wire enable;  
	wire ready;
	wire [15:0] data;   
	reg [6:0] Address_in; 
	
	//regs for binary to decimal conversion
	reg [32:0] decimal;   
	reg [3:0] dig0;
	reg [3:0] dig1;
	reg [3:0] dig2;
	reg [3:0] dig3;
	reg [3:0] dig4;
	reg [3:0] dig5;
	reg [3:0] dig6;
	
   
	//xadc connection
	xadc_wiz_0  XLXI_7 (.daddr_in(Address_in),
						.dclk_in(clk), 
						.den_in(enable), 
						.di_in(), 
						.dwe_in(), 
						.busy_out(),                    
						.vauxp6(vauxp6),
						.vauxn6(vauxn6),
						.vauxp7(vauxp7),
						.vauxn7(vauxn7),
						.vn_in(), 
						.vp_in(), 
						.alarm_out(), 
						.do_out(data), 
						.eoc_out(enable),
						.channel_out(),
						.drdy_out(ready));
                     
         
    
	//display adc output on LEDS        
	always @( posedge(clk))
		begin            
			if(ready == 1'b1)
			begin
				case (data[15:12])
					1:  LED <= 16'b11;
					2:  LED <= 16'b111;
					3:  LED <= 16'b1111;
					4:  LED <= 16'b11111;
					5:  LED <= 16'b111111;
					6:  LED <= 16'b1111111; 
					7:  LED <= 16'b11111111;
					8:  LED <= 16'b111111111;
					9:  LED <= 16'b1111111111;
					10: LED <= 16'b11111111111;
					11: LED <= 16'b111111111111;
					12: LED <= 16'b1111111111111;
					13: LED <= 16'b11111111111111;
					14: LED <= 16'b111111111111111;
					15: LED <= 16'b1111111111111111;                        
					default: LED <= 16'b1; 
				endcase
			end 
		end
      
     
//binary to decimal conversion

	reg [32:0] count; 
	
	always @ (posedge clk)
		begin

		if(count == 10000000)
		begin
            //16 bit = 65536 values
            //shifted 4 = 4096 values
			decimal = data >> 4;
            begin
            decimal = decimal * 250000;
            //4096*250000 = 1024000000
            decimal = decimal >> 10;
            //shift 10 = 1000000

            dig0 = decimal % 10;
            decimal = decimal / 10;

            dig1 = decimal % 10;
            decimal = decimal / 10;
               
            dig2 = decimal % 10;
            decimal = decimal / 10;

            dig3 = decimal % 10;
            decimal = decimal / 10;

            dig4 = decimal % 10;
            decimal = decimal / 10;
               
            dig5 = decimal % 10;
            decimal = decimal / 10; 

            dig6 = decimal % 10;
            decimal = decimal / 10; 

            count = 0;
            end
		end

		count = count + 1;

	end
    
    //Change the input between the 10k Pot and the LM35
	always @(posedge(clk))
	begin
		if(sw == 0)
			Address_in <= 8'h16;
		else
			Address_in <= 8'h17;

	end

    //PWM connection
	PWM_Counter pwm1(.clk(clk),
					.data(data),
					.pwm(pwm)
	);   

	//lcd module connection
	LCD_Module lcd1(.clk(clk),
					.lcd_rs(lcd_rs),
					.lcd_rw(lcd_rw),
					.lcd_e(lcd_e),
					.lcd_7(lcd_7),
					.lcd_6(lcd_6),
					.lcd_5(lcd_5),
					.lcd_4(lcd_4),
					.lcd_3(lcd_3),
					.lcd_2(lcd_2),
					.lcd_1(lcd_1),
					.lcd_0(lcd_0),
					.dig3(dig3),
					.dig4(dig4),
					.dig5(dig5),
					.dig6(dig6),
					.sw(sw));      

endmodule
