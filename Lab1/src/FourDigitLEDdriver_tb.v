module FourDigitLEDdriver_tb;
    reg clk, reset;
    wire [3:0] AN;
    wire CA, CB, CC, CD, CE, CF, CG, dp;
    wire [6:0] LED = {CA, CB, CC, CD, CE, CF, CG};
    wire [615:0] display0 = AN[0] == 0 ? {" ", CA ? "aaaa" : "    ", " \n", 
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    " ", CG ? "gggg" : "    ", " \n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    " ", CD ? "dddd" : "    ", " \n"} : {77{""}};
    wire [615:0] display1 = AN[1] == 0 ? {" ", CA ? "aaaa" : "    ", " \n", 
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    " ", CG ? "gggg" : "    ", " \n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    " ", CD ? "dddd" : "    ", " \n"} : {77{""}};
    wire [615:0] display2 = AN[2] == 0 ? {" ", CA ? "aaaa" : "    ", " \n", 
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    " ", CG ? "gggg" : "    ", " \n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    " ", CD ? "dddd" : "    ", " \n"} : {77{""}};
    wire [615:0] display3 = AN[3] == 0 ? {" ", CA ? "aaaa" : "    ", " \n", 
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    CF ? "f" : " ", "    ", CB ? "b" : " ", "\n",
    " ", CG ? "gggg" : "    ", " \n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    CE ? "e" : " ", "    ", CC ? "c" : " ", "\n",
    " ", CD ? "dddd" : "    ", " \n"} : {77{""}};

    FourDigitLEDdriver driver(.clk(clk), .reset(reset), .an3(AN[3]), .an2(AN[2]), .an1(AN[1]), .an0(AN[0]), .a(CA), .b(CB), .c(CC), .d(CD), .e(CE), .f(CF), .g(CG), .dp(dp));

    initial begin
        $dumpfile("FourDigitLEDdriver_tb.vcd");
        $dumpvars(0, FourDigitLEDdriver_tb);
        $monitor("time = %t, AN = %b, LED = %b\n, display0 = \n%s\n, display1 = \n%s\n, display2 = \n%s\n, display3 = \n%s\n", $time, AN, LED, display0, display1, display2, display3);
        clk = 0;
        reset = 0;
        #10 reset = 1;
        #10 reset = 0;
        #200 $finish;
    end

    always begin
        #5 clk = ~clk;
    end
endmodule