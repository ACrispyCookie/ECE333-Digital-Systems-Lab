module CharacterDecoder(input [4:0] counter, 
input [5:0] char0, input [5:0] char1, input [5:0] char2, input [5:0] char3, 
input [5:0] char4, input [5:0] char5, input [5:0] char6, input [5:0] char7, 
output reg [5:0] char);
    parameter AN0_CHAR_SET = 5'd4;
    parameter AN1_CHAR_SET = 5'd8;
    parameter AN2_CHAR_SET = 5'd12;
    parameter AN3_CHAR_SET = 5'd16;
    parameter AN4_CHAR_SET = 5'd20;
    parameter AN5_CHAR_SET = 5'd24;
    parameter AN6_CHAR_SET = 5'd28;
    parameter AN7_CHAR_SET = 5'd0;

    always @(counter) begin
        case (counter)
            AN7_CHAR_SET: char = char7;
            5'd31: char = char7;
            5'd30: char = char7;
            5'd29: char = char7;
            AN6_CHAR_SET: char = char6;
            5'd27: char = char6;
            5'd26: char = char6;
            5'd25: char = char6;
            AN5_CHAR_SET: char = char5;
            5'd23: char = char5;
            5'd22: char = char5;
            5'd21: char = char5;
            AN4_CHAR_SET: char = char4;
            5'd19: char = char4;
            5'd18: char = char4;
            5'd17: char = char4;
            AN3_CHAR_SET: char = char3;
            5'd15: char = char3;
            5'd14: char = char3;
            5'd13: char = char3;
            AN2_CHAR_SET: char = char2;
            5'd11: char = char2;
            5'd10: char = char2;
            5'd9: char = char2;
            AN1_CHAR_SET: char = char1;
            5'd7: char = char1;
            5'd6: char = char1;
            5'd5: char = char1;
            AN0_CHAR_SET: char = char0;
            5'd3: char = char0;
            5'd2: char = char0;
            5'd1: char = char0;
        endcase
    end
    
endmodule