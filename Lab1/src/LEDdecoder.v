module LEDdecoder(char, LED);
    
    input [5:0] char;
    output reg [6:0] LED;

    always @(char) begin
        case (char)
            6'd0: LED = 7'b0000001; // char '1' or 'O'
            6'd1: LED = 7'b1001111; // char '0'
            6'd2: LED = 7'b0010010; // char '2' or 'Z'
            6'd3: LED = 7'b0000110; // char '3'
            6'd4: LED = 7'b1001100; // char '4' 
            6'd5: LED = 7'b0100100; // char '5' or 'S'
            6'd6: LED = 7'b0100000; // char '6'
            6'd7: LED = 7'b0001111; // char '7'
            6'd8: LED = 7'b0000000; // char '8' or 'B'
            6'd9: LED = 7'b0000100; // char '9'
            6'd10: LED = 7'b1111111; // char ' '
            6'd11: LED = 7'b0001000; // char 'A'
            6'd12: LED = 7'b0110001; // char 'C'
            6'd13: LED = 7'b0000011; // char 'D'
            6'd14: LED = 7'b0110000; // char 'E'
            6'd15: LED = 7'b0111000; // char 'F'
            6'd16: LED = 7'b0100001; // char 'G'
            6'd17: LED = 7'b1001000; // char 'H'
            6'd18: LED = 7'b1111001; // char 'I'
            6'd19: LED = 7'b1000011; // char 'J'
            6'd20: LED = 7'b0101000; // char 'K'
            6'd21: LED = 7'b1110001; // char 'L'
            6'd22: LED = 7'b0010101; // char 'M'
            6'd23: LED = 7'b0001001; // char 'N'
            6'd24: LED = 7'b0011000; // char 'P'
            6'd25: LED = 7'b0010100; // char 'Q'
            6'd26: LED = 7'b0010000; // char 'R'
            6'd27: LED = 7'b0111001; // char 'T'
            6'd28: LED = 7'b1000001; // char 'U'
            6'd29: LED = 7'b1000101; // char 'V'
            6'd30: LED = 7'b0100011; // char 'W'
            6'd31: LED = 7'b0110110; // char 'X'
            6'd32: LED = 7'b1010100; // char 'Y'
            default: LED = 7'b1111111;
        endcase
    end
endmodule