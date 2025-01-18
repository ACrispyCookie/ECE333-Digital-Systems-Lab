module AnodeDecoder(input [4:0] counter, output reg an0, output reg an1, output reg an2, output reg an3, output reg an4, output reg an5, output reg an6, output reg an7);
    parameter AN0_OFF = 5'b00010;
    parameter AN1_OFF = 5'b00110;
    parameter AN2_OFF = 5'b01010;
    parameter AN3_OFF = 5'b01110;
    parameter AN4_OFF = 5'b10010;
    parameter AN5_OFF = 5'b10110;
    parameter AN6_OFF = 5'b11010;
    parameter AN7_OFF = 5'b11110;

    always @(counter) begin
        case (counter)
            AN0_OFF: begin
                an0 = 1'b0;
                an1 = 1'b1;
                an2 = 1'b1;
                an3 = 1'b1;
                an4 = 1'b1;
                an5 = 1'b1;
                an6 = 1'b1;
                an7 = 1'b1;
            end
            AN1_OFF: begin
                an0 = 1'b1;
                an1 = 1'b0;
                an2 = 1'b1;
                an3 = 1'b1;
                an4 = 1'b1;
                an5 = 1'b1;
                an6 = 1'b1;
                an7 = 1'b1;
            end
            AN2_OFF: begin
                an0 = 1'b1;
                an1 = 1'b1;
                an2 = 1'b0;
                an3 = 1'b1;
                an4 = 1'b1;
                an5 = 1'b1;
                an6 = 1'b1;
                an7 = 1'b1;
            end
            AN3_OFF: begin
                an0 = 1'b1;
                an1 = 1'b1;
                an2 = 1'b1;
                an3 = 1'b0;
                an4 = 1'b1;
                an5 = 1'b1;
                an6 = 1'b1;
                an7 = 1'b1;
            end
            AN4_OFF: begin
                an0 = 1'b1;
                an1 = 1'b1;
                an2 = 1'b1;
                an3 = 1'b1;
                an4 = 1'b0;
                an5 = 1'b1;
                an6 = 1'b1;
                an7 = 1'b1;
            end
            AN5_OFF: begin
                an0 = 1'b1;
                an1 = 1'b1;
                an2 = 1'b1;
                an3 = 1'b1;
                an4 = 1'b1;
                an5 = 1'b0;
                an6 = 1'b1;
                an7 = 1'b1;
            end
            AN6_OFF: begin
                an0 = 1'b1;
                an1 = 1'b1;
                an2 = 1'b1;
                an3 = 1'b1;
                an4 = 1'b1;
                an5 = 1'b1;
                an6 = 1'b0;
                an7 = 1'b1;
            end
            AN7_OFF: begin
                an0 = 1'b1;
                an1 = 1'b1;
                an2 = 1'b1;
                an3 = 1'b1;
                an4 = 1'b1;
                an5 = 1'b1;
                an6 = 1'b1;
                an7 = 1'b0;
            end
            default: begin
                an0 = 1'b1;
                an1 = 1'b1;
                an2 = 1'b1;
                an3 = 1'b1;
                an4 = 1'b1;
                an5 = 1'b1;
                an6 = 1'b1;
                an7 = 1'b1;
            end
        endcase
    end
    
endmodule