module CharacterMemory(input clk, input reset, input [4:0] address, output reg [5:0] char0, output reg [5:0] char1, output reg [5:0] char2, output reg [5:0] char3);
    reg [5:0] memory [27:0];

    always @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin
            memory[0] <= 6'd23; //N
            memory[1] <= 6'd14; //E
            memory[2] <= 6'd29; //V
            memory[3] <= 6'd14; //E
            memory[4] <= 6'd26; //R
            memory[5] <= 6'd10; // 
            memory[6] <= 6'd16; //G
            memory[7] <= 6'd0; //O
            memory[8] <= 6'd23; //N
            memory[9] <= 6'd23; //N
            memory[10] <= 6'd11; //A
            memory[11] <= 6'd10; //
            memory[12] <= 6'd16; //G
            memory[13] <= 6'd18; //I
            memory[14] <= 6'd29; //V
            memory[15] <= 6'd14; //E
            memory[16] <= 6'd10; //
            memory[17] <= 6'd32; //Y
            memory[18] <= 6'd0; //O
            memory[19] <= 6'd28; //U
            memory[20] <= 6'd10; //
            memory[21] <= 6'd28; //U
            memory[22] <= 6'd24; //P
            memory[23] <= 6'd10; //
            memory[24] <= 6'd10; //
            memory[25] <= 6'd10; //
            memory[26] <= 6'd10; //
            memory[27] <= 6'd10; //
            char0 <= 6'd10;
            char1 <= 6'd10;
            char2 <= 6'd10;
            char3 <= 6'd10;
        end else begin
            char0 <= memory[address];
            char1 <= memory[address + 1];
            char2 <= memory[address + 2];
            char3 <= memory[address + 3];
        end
    end
endmodule