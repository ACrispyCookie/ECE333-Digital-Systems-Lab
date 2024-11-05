module message_counter(clk, reset, enable, next, current_message, next_pulse);
    input clk, reset, enable, next;
    output reg [1:0] current_message;
    output next_pulse;

    reg next_1, next_2;
    wire next_pulse = next_1 && ~next_2;

    always @(posedge clk or posedge reset) begin
        if (reset || !enable) begin
            current_message <= 2'b0;
        end else if (next_pulse && current_message != 2'b11) begin
            current_message <= current_message + 2'b1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || !enable) begin
            next_1 <= 1'b1;
            next_2 <= 1'b1;
        end else begin
            next_1 <= next;
            next_2 <= next_1;
        end
    end

endmodule