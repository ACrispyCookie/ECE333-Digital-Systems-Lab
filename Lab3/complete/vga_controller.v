module vga_controller (
    reset,
    clk,
    enable,
    vga_red,
    vga_green,
    vga_blue,
    vga_hsync,
    vga_vsync
);

    input reset, clk, enable;

    output vga_red, vga_green, vga_blue;
    output vga_hsync, vga_vsync;

    wire [6:0] hpixel, vpixel;
    wire [2:0] hpixel_upscale_counter;
    wire hrgb_enabled, vrgb_enabled;

    clock_divider clock_divider_inst(.clk(clk), .new_clk(new_clk));
    
    pixel_controller #(
        .UPSCALE_WIDTH(3),
        .UPSCALE_CYCLES(4)
    )
    pixel_controller_inst(.clk(new_clk), .reset(reset), .hrgb_enabled(hrgb_enabled), .vrgb_enabled(vrgb_enabled), 
    .hpixel(hpixel), .hpixel_upscale_counter(hpixel_upscale_counter), .vpixel(vpixel), .r(vga_red), .g(vga_green), .b(vga_blue));

    // Horizontal sync controller
    gsync_controller #(
        .COUNTER_WIDTH(10),
        .PULSE_CYCLES(95),
        .BACK_PORCH_CYCLES(47),
        .DISPLAY_CYCLES(639),
        .FRONT_PORCH_CYCLES(15),
        .UPSCALE_WIDTH(3),
        .UPSCALE_CYCLES(4)
    )
    hsync_controller_inst(.clk(new_clk), .reset(reset), .enable(enable), .sync(vga_hsync), .rgb_enabled(hrgb_enabled), .pixel(hpixel), .upscale_counter(hpixel_upscale_counter));

    // Vertical sync controller
    gsync_controller #(
        .COUNTER_WIDTH(19),
        .PULSE_CYCLES(1599),
        .BACK_PORCH_CYCLES(23199),
        .DISPLAY_CYCLES(383999),
        .FRONT_PORCH_CYCLES(7999),
        .UPSCALE_WIDTH(12),
        .UPSCALE_CYCLES(3999)
    )
    vsync_controller_inst(.clk(new_clk), .reset(reset), .enable(enable), .sync(vga_vsync), .rgb_enabled(vrgb_enabled), .pixel(vpixel));

endmodule