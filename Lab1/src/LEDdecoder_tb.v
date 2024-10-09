`timescale 1ns/10ps
module LEDdecoder_tb;
    reg [5:0] char;
    wire [6:0] LED;
    wire CA = LED[6], CB = LED[5], CC = LED[4], CD = LED[3], CE = LED[2], CF = LED[1], CG = LED[0];


    LEDdecoder decoder(char, LED);
    wire [615:0] display = {" ", !CA ? "aaaa" : "    ", " \n", 
    !CF ? "f" : " ", "    ", !CB ? "b" : " ", "\n",
    !CF ? "f" : " ", "    ", !CB ? "b" : " ", "\n",
    !CF ? "f" : " ", "    ", !CB ? "b" : " ", "\n",
    !CF ? "f" : " ", "    ", !CB ? "b" : " ", "\n",
    " ", !CG ? "gggg" : "    ", " \n",
    !CE ? "e" : " ", "    ", !CC ? "c" : " ", "\n",
    !CE ? "e" : " ", "    ", !CC ? "c" : " ", "\n",
    !CE ? "e" : " ", "    ", !CC ? "c" : " ", "\n",
    !CE ? "e" : " ", "    ", !CC ? "c" : " ", "\n",
    " ", !CD ? "dddd" : "    ", " \n"};

    initial begin
        $dumpfile("LEDdecoder_tb.vcd");
        $dumpvars(0, LEDdecoder_tb);
        $monitor("time = %t, char = %d, LED = %b, display = \n%s", $time, char, LED, display);
        char = 6'd0;
        #10 char = 6'd1;
        #10 char = 6'd2;
        #10 char = 6'd3;
        #10 char = 6'd4;
        #10 char = 6'd5;
        #10 char = 6'd6;
        #10 char = 6'd7;
        #10 char = 6'd8;
        #10 char = 6'd9;
        #10 char = 6'd10;
        #10 char = 6'd11;
        #10 char = 6'd12;
        #10 char = 6'd13;
        #10 char = 6'd14;
        #10 char = 6'd15;
        #10 char = 6'd16;
        #10 char = 6'd17;
        #10 char = 6'd18;
        #10 char = 6'd19;
        #10 char = 6'd20;
        #10 char = 6'd21;
        #10 char = 6'd22;
        #10 char = 6'd23;
        #10 char = 6'd24;
        #10 char = 6'd25;
        #10 char = 6'd26;
        #10 char = 6'd27;
        #10 char = 6'd28;
        #10 char = 6'd29;
        #10 char = 6'd30;
        #10 char = 6'd31;
        #10 char = 6'd32;
        #10 $finish;
    end


endmodule