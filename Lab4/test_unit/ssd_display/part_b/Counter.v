module Counter(input clk, input reset, output reg [4:0] counter);
    
    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1)
            counter <= 5'b11111;
        else
            counter <= counter - 5'b1;
    end
endmodule