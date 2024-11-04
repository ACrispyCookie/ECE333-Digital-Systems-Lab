module InputDebouncer(input clk, input reset, input input_bounce, output reg debounced, output wire posedge_pulse, output wire negedge_pulse);
    wire input_1;
    reg input_2;
    reg [12:0] counter;
    reg last_state;
    wire counter_running = ~(input_1 ^ input_2);
    assign posedge_pulse = counter_running && counter == 4'b1111 && debounced && ~last_state;
    assign negedge_pulse = counter_running && counter == 4'b1111 && ~debounced && last_state;

    InputSynchronizer sync_inst(.clk(clk), .async_input(input_bounce), .sync_input(input_1));

    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1)
            input_2 <= 1'b0;    
        else 
            input_2 <= input_1;    
    end

    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            last_state <= 1'b0;
            debounced <= 1'b0;
        end else begin
            if (counter == 4'b1111) begin
                last_state <= debounced;
                debounced <= input_2;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            counter <= 13'b0;
        end else begin
            if (counter_running) begin
                counter <= counter + 13'b1;
            end else begin
                counter <= 13'b0;
            end
        end
    end

endmodule