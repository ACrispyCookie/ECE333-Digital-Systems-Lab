module OneSecondCounter(input clk, input reset, output reg [4:0] address);
    reg [22:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            counter = 23'b0;
            address = 5'b0;
        end
        else begin
            counter = counter + 23'b1;
            if (counter == 23'h7fffff) begin
                if (address == 5'b10110)
                    address = 5'b0;
                else 
                    address = address + 5'b1;
            end
        end
    end

endmodule