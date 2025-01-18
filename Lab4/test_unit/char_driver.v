module char_driver (
    clk,
    reset,
    simple_mode,
    no_avg,
    binary_select,
    x_sel,
    y_sel,
    z_sel,
    t_sel,
    x_binary,
    y_binary,
    z_binary,
    t_binary,
    x_avg,
    y_avg,
    z_avg,
    t_avg,
    char0,
    char1,
    char2,
    char3,
    char4,
    char5,
    char6,
    char7
);

input clk, reset, simple_mode, no_avg, binary_select, x_sel, y_sel, z_sel, t_sel;
input [11:0] x_binary, y_binary, z_binary;
input [18:0] t_binary;
input [11:0] x_avg, y_avg, z_avg;
input [18:0] t_avg;
output reg [5:0] char0, char1, char2, char3, char4, char5, char6, char7;

always @(simple_mode or no_avg or binary_select or x_sel or y_sel or z_sel) begin
    if (simple_mode) begin
        if (no_avg) begin
            {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = x_binary[7:0];
        end else begin
            {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = x_avg[7:0];
        end
    end else begin
        if (no_avg) begin
            if (x_sel) begin
                {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = binary_select ? x_binary[11:8] : x_binary[7:0];
            end else if (y_sel) begin
                {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = binary_select ? y_binary[11:8] : y_binary[7:0];
            end else if (z_sel) begin
                {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = binary_select ? z_binary[11:8] : z_binary[7:0];
            end else begin
                {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = binary_select ? t_binary[18:15] : t_binary[14:7];
            end
        end else begin
            if (x_sel) begin
                {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = binary_select ? x_avg[11:8] : x_avg[7:0];
            end else if (y_sel) begin
                {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = binary_select ? y_avg[11:8] : y_avg[7:0];
            end else if (z_sel) begin
                {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = binary_select ? z_avg[11:8] : z_avg[7:0];
            end else begin
                {char0[0], char1[0], char2[0], char3[0], char4[0], char5[0], char6[0], char7[0]} = binary_select ? t_avg[18:15] : t_avg[14:7];
            end
        end
    end
end
    
endmodule