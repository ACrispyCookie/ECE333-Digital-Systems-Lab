module clock_divider (
    clk,
    reset,
    new_clk,
    locked_sync
);

    input clk, reset;
    output new_clk;
    output reg locked_sync;

    wire locked;

    always @(posedge new_clk or posedge reset) begin
      if (reset)
        locked_sync <= 1'b0;
      else
        locked_sync <= locked;
    end

    MMCME2_BASE #(
      .CLKFBOUT_MULT_F(6.0),
      .CLKIN1_PERIOD(10.0),
      .CLKOUT0_DIVIDE_F(120.0),
      .DIVCLK_DIVIDE(1)         // Master division value (1-106)
    )
   
    MMCME2_BASE_inst (
      .CLKOUT0(new_clk),     // 1-bit output: CLKOUT0
      .CLKFBOUT(feedback),   // 1-bit output: Feedback clock
      .CLKIN1(clk),       // 1-bit input: Clock
      .CLKFBIN(feedback),      // 1-bit input: Feedback clock
      .LOCKED(locked)
    );
    
endmodule