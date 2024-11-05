module receiver_memory(clk, reset, address, write, data_in, data_out_0, data_out_1, data_out_2, data_out_3);
    input clk, reset, write;
    input [1:0] address;
    input [7:0] data_in;
    output data_out_0, data_out_1, data_out_2, data_out_3;

    reg [7:0] memory [3:0];
    wire [7:0] data_out_0 = memory[0];
    wire [7:0] data_out_1 = memory[1];
    wire [7:0] data_out_2 = memory[2];
    wire [7:0] data_out_3 = memory[3];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory[0] <= 8'b0;
            memory[1] <= 8'b0;
            memory[2] <= 8'b0;
            memory[3] <= 8'b0;
        end else if (write) begin
            memory[address] <= data_in;
        end
    end
    
endmodule