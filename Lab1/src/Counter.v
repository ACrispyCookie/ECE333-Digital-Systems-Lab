module Counter(input clk, input reset, output reg [3:0] counter);
    
    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1)
            counter = 4'b1111;
        else
            counter = counter + 1'b1;
    end
endmodule