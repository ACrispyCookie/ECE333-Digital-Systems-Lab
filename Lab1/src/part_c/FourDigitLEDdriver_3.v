module FourDigitLEDdriver(reset, button, clk, an3, an2, an1, an0,
a, b, c, d, e, f, g, dp);

    input clk, reset, button;
    output wire an3, an2, an1, an0, a, b, c, d, e, f, g, dp;
    wire [3:0] counter;
    wire [5:0] characters [3:0];
    wire [5:0] char;
    wire feedback, reset_sync, button_sync, slow_clk, char_address, button_on;
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
    InputDebouncer debouncer_button(.clk(slow_clk), .input_bounce(button), .debounced(button_sync), .debounced_on(button_on));
    ButtonCounter button_counter(.clk(slow_clk), .reset(reset_sync), .button(button_on), .button_counter(char_address));
    CharacterMemory memory(.clk(slow_clk), .reset(reset_sync), .address(char_address), .char0(characters[0]), .char1(characters[1]), .char2(characters[2]), .char3(characters[3]));
    AnodeDecoder anode_decoder(.counter(counter), .an0(an0), .an1(an1), .an2(an2), .an3(an3));
    CharacterDecoder char_decoder(.counter(counter), .char0(characters[0]), .char1(characters[1]), .char2(characters[2]), .char3(characters[3]), .char(char));
    LEDdecoder LEDdecoder_inst(.char(char), .LED({a, b, c, d, e, f, g}));

endmodule