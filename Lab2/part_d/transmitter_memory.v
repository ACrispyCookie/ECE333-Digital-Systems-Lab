module transmitter_memory(clk, reset, address, data);
    input clk, reset;
    input [1:0] address;
    output data;

    reg [7:0] memory [3:0];
    wire [7:0] data = memory[address];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory[0] <= 8'haa;
            memory[1] <= 8'h55;
            memory[2] <= 8'hcc;
            memory[3] <= 8'h89;
        end
    end

endmodule