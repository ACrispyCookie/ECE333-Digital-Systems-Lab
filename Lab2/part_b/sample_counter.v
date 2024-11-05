module sample_counter(clk, reset, enable, sample_pulse, sample_counter);
    input clk, reset, enable, sample_pulse;
    output reg [3:0] sample_counter;

    always @(posedge clk or posedge reset) begin
        if (reset || !enable) begin
            sample_counter <= 4'b0;
        end else if (sample_pulse) begin
            sample_counter <= sample_counter + 4'b1;
        end
    end
    
endmodule