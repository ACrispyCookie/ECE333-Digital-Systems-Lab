module CharacterDecoder(input [3:0] counter, output reg [5:0] char);
    parameter AN0_CHAR_SET = 4'b0000;
    parameter AN1_CHAR_SET = 4'b0100;
    parameter AN2_CHAR_SET = 4'b1000;
    parameter AN3_CHAR_SET = 4'b1100;

    always @(counter) begin
        case (counter)
            AN0_CHAR_SET: char = 6'd19;
            4'b0001: char = 6'd19;
            4'b0010: char = 6'd19;
            4'b0011: char = 6'd19;
            AN1_CHAR_SET: char = 6'd5;
            4'b0101: char = 6'd5;
            4'b0110: char = 6'd5;
            4'b0111: char = 6'd5;
            AN2_CHAR_SET: char = 6'd0;
            4'b1001: char = 6'd0;
            4'b1010: char = 6'd0;
            4'b1011: char = 6'd0;
            AN3_CHAR_SET: char = 6'd23;
            4'b1101: char = 6'd23;
            4'b1110: char = 6'd23;
            4'b1111: char = 6'd23;
        endcase
    end
    
endmodule