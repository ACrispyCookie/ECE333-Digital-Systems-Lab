module receiver_sampler(clk, reset, counter_enable, sampler_enable, sample_pulse, data, sample_mid, sample_done, previous_bit, current_bit);
    input clk, reset, counter_enable, sampler_enable, sample_pulse, data;
    output reg previous_bit, current_bit;
    output wire sample_mid, sample_done;
    assign sample_mid = sample_counter == 4'd8 && sample_mid;
    assign sample_done = sample_counter == 4'd15 && sample_pulse;

    wire [3:0] sample_counter;
    sample_counter sample_counter_inst(.clk(clk), .reset(reset), .enable(counter_enable), .sample_pulse(sample_pulse), .sample_counter(sample_counter));

    always @(posedge clk or posedge reset) begin
        if (reset || !sampler_enable) begin
            previous_bit <= 1'b0;
        end else if (sampler_enable && sample_counter == 4'b0000 && sample_pulse) begin
            previous_bit <= data;
        end else if (sampler_enable && sample_counter[0] == 1'b0 && sample_pulse) begin
            previous_bit <= sampled_bit;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || !sampler_enable) begin
            sampled_bit <= 1'b0;
        end else if (sampler_enable && sample_counter[0] == 1'b0 && sample_pulse) begin
            sampled_bit <= data;
        end
    end
    
endmodule