module CharacterDecoder(input [3:0] counter, input [5:0] char0, input [5:0] char1, input [5:0] char2, input [5:0] char3, output reg [5:0] char);
    parameter AN3_CHAR_SET = 4'b0000;
    parameter AN2_CHAR_SET = 4'b1100;
    parameter AN1_CHAR_SET = 4'b1000;
    parameter AN0_CHAR_SET = 4'b0100;

    always @(counter or char0 or char1 or char2 or char3) begin
        case (counter)
            AN3_CHAR_SET: char = char3;
            4'b0001: char = char3;
            4'b0010: char = char3;
            4'b0011: char = char3;
            AN0_CHAR_SET: char = char2;
            4'b0101: char = char2;
            4'b0110: char = char2;
            4'b0111: char = char2;
            AN1_CHAR_SET: char = char1;
            4'b1001: char = char1;
            4'b1010: char = char1;
            4'b1011: char = char1;
            AN2_CHAR_SET: char = char0;
            4'b1101: char = char0;
            4'b1110: char = char0;
            4'b1111: char = char0;
        endcase
    end
    
endmodule