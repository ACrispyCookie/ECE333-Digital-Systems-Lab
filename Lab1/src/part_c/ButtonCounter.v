module ButtonCounter(input clk, input reset, input button, output reg [4:0] button_counter);
    
    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1)
            button_counter = 5'b0;
        if (button == 1'b1) begin
            if (button_counter == 5'd22)
                button_counter = 5'b0;
            else 
                button_counter = button_counter + 5'b1;
        end
    end

endmodule