module ResetDebouncer(input clk, input input_bounce, output reg debounced, output wire debounced_on, output wire debounced_off);
    wire input_1;
    reg input_2;
    reg [16:0] counter;
    wire counter_running;
    assign counter_running = ~(input_1 ^ input_2);
    assign debounced_on = counter_running && counter == RESET_TIME && debounced;
    assign debounced_off = counter_running && counter == RESET_TIME && ~debounced;

    localparam RESET_TIME = 17'd100000;

    ResetSynchronizer sync_inst(.clk(clk), .async_input(input_bounce), .sync_input(input_1));

    always @(posedge clk) begin
        input_2 <= input_1;    
    end

    always @(posedge clk) begin
        if (counter == RESET_TIME) begin
            debounced <= input_2;
        end
        
        if (counter_running) begin
            counter <= counter + 17'b1;
        end else begin
            counter <= 17'b0;
        end
    end

endmodule