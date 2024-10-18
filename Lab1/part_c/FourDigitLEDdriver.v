module FourDigitLEDdriver(reset, button, clk, an3, an2, an1, an0,
a, b, c, d, e, f, g, dp);

    input clk, reset, button;
    output wire an3, an2, an1, an0, a, b, c, d, e, f, g, dp;
    wire [3:0] counter;
    wire [5:0] char0, char1, char2, char3;
    wire [5:0] char;
    wire [4:0] char_address;
    wire feedback, reset_sync, slow_clk, button_on;
    assign dp = 1'b1;

     MMCME2_BASE #(
      .CLKFBOUT_MULT_F(6.0),
      .CLKIN1_PERIOD(10.0),
      .CLKOUT0_DIVIDE_F(120.0),
      .DIVCLK_DIVIDE(1)         // Master division value (1-106)
    )
   
    MMCME2_BASE_inst (
      .CLKOUT0(slow_clk),     // 1-bit output: CLKOUT0
      .CLKFBOUT(feedback),   // 1-bit output: Feedback clock
      .CLKIN1(clk),       // 1-bit input: Clock
      .CLKFBIN(feedback)      // 1-bit input: Feedback clock
    );

    InputDebouncer debouncer(.clk(slow_clk), .input_bounce(reset), .debounced(reset_sync));
    Counter counter_inst(.clk(slow_clk), .reset(reset_sync), .counter(counter));
    ButtonDebouncer debouncer_button(.clk(slow_clk), .reset(reset_sync), .input_bounce(button), .debounced_on(button_on));
    ButtonCounter button_counter(.clk(slow_clk), .reset(reset_sync), .button(button_on), .button_counter(char_address));
    CharacterMemory memory(.clk(slow_clk), .reset(reset_sync), .address(char_address), .char0(char0), .char1(char1), .char2(char2), .char3(char3));
    AnodeDecoder anode_decoder(.counter(counter), .an0(an0), .an1(an1), .an2(an2), .an3(an3));
    CharacterDecoder char_decoder(.counter(counter), .char0(char0), .char1(char1), .char2(char2), .char3(char3), .char(char));
    LEDdecoder LEDdecoder_inst(.char(char), .LED({a, b, c, d, e, f, g}));

endmodule