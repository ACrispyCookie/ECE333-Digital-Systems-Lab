module avg_calc (
    clk,
    reset,
    x_binary,
    y_binary,
    z_binary,
    t_binary,
    x_avg,
    y_avg,
    z_avg,
    t_avg,
    copy_values,
    ready
);

    input clk, reset, copy_values;
    input signed [11:0] x_binary, y_binary, z_binary;
    input signed [18:0] t_binary;
    output reg signed [11:0] x_avg, y_avg, z_avg;
    output reg signed [18:0] t_avg;
    output reg ready;

    reg signed [17:0] partial_sum_x, partial_sum_y, partial_sum_z;
    reg signed [24:0] partial_sum_t;
    reg [5:0] partial_sum_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            partial_sum_x <= 18'd0;
            partial_sum_y <= 18'd0;
            partial_sum_z <= 18'd0;
            partial_sum_t <= 25'd0;
        end else if (copy_values) begin
            if (partial_sum_count == 6'd0) begin
                partial_sum_x <= x_binary;
                partial_sum_y <= y_binary;
                partial_sum_z <= z_binary;
                partial_sum_t <= t_binary;
            end else begin
                partial_sum_x <= partial_sum_x + x_binary;
                partial_sum_y <= partial_sum_y + y_binary;
                partial_sum_z <= partial_sum_z + z_binary;
                partial_sum_t <= partial_sum_t + t_binary;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            partial_sum_count <= 7'd0;
        end else if (copy_values) begin
            partial_sum_count <= partial_sum_count + 7'b1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ready <= 1'b0;
        end else if (copy_values && partial_sum_count == 6'd63) begin
            ready <= 1'b1;
        end else begin
            ready <= 1'b0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_avg <= 12'd0;
            y_avg <= 12'd0;
            z_avg <= 12'd0;
            t_avg <= 19'd0;
        end else if (copy_values && partial_sum_count == 6'd63) begin
            x_avg <= (partial_sum_x + x_binary) >>> 3'd6;
            y_avg <= (partial_sum_y + y_binary) >>> 3'd6;
            z_avg <= (partial_sum_z + z_binary) >>> 3'd6;
            t_avg <= (partial_sum_t + t_binary) >>> 3'd6;
        end
    end
    
endmodule