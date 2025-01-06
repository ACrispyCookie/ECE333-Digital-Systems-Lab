module avg_calc (
    clk,
    reset,
    next_value,
    copy_value,
    avg_value,
    ready
);

    input clk, reset, next_value, copy_value;
    output reg [13:0] avg_value;
    output reg ready;

    reg [20:0] partial_sum;
    reg [6:0] partial_sum_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            partial_sum <= 21'd0;
        end else if (copy_value) begin
            if (partial_sum_count == 7'd0)
                partial_sum <= next_value;
            else
                partial_sum <= partial_sum + next_value;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            partial_sum_count <= 7'd0;
        end else if (copy_value) begin
            partial_sum_count <= partial_sum_count + 7'b1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ready <= 1'b0;
        end else if (copy_value && partial_sum_count == 7'd127) begin
            ready <= 1'b1;
        end else begin
            ready <= 1'b0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            avg_value <= 14'd0;
        end else if (copy_value && partial_sum_count == 7'd127) begin
            avg_value <= partial_sum >> 7;
        end
    end
    
endmodule