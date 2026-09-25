`timescale 1ns/10ps
module uart_controller_tb;
    reg clk, reset;
    wire [7:0] message_0, message_1, message_2, message_3;
    wire [3:0] baud_select;
    wire tx_end, errorred, rx_valid;
    reg [2:0] current_state, next_state;
    reg tx_en, rx_en, tx_wr;
    assign baud_select = 3'b111;

    parameter IDLE = 3'd0;
    parameter TRANSMITTING = 3'd1;
    parameter WAIT_TO_START = 3'd2;
    parameter WAIT_TO_END = 3'd3;
    parameter END_STATE = 3'd4;
    
    uart_controller uart_controller_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .tx_en(tx_en), .rx_en(rx_en), .tx_wr(tx_wr), .tx_end(tx_end), .rx_valid(rx_valid),
    .errorred(errorred), .message_0(message_0), .message_1(message_1), .message_2(message_2), .message_3(message_3));

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or errorred or tx_end or rx_valid) begin
        case (current_state)
            IDLE: next_state = TRANSMITTING;
            TRANSMITTING: next_state = WAIT_TO_START;
            WAIT_TO_START: begin
                if (errorred || tx_end) begin
                    next_state = END_STATE;
                end else if (!rx_valid) begin
                    next_state = WAIT_TO_END;
                end else begin
                    next_state = WAIT_TO_START;
                end
            end
            WAIT_TO_END: begin
                if (errorred || tx_end) begin
                    next_state = END_STATE;
                end else if (rx_valid) begin
                    next_state = TRANSMITTING;
                end else begin
                    next_state = WAIT_TO_END;
                end
            end
            END_STATE: begin
                next_state = END_STATE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(current_state) begin
        case (current_state)
            IDLE: begin
                tx_en = 1'b1;
                rx_en = 1'b1;
                tx_wr = 1'b0;
            end
            TRANSMITTING: begin
                tx_en = 1'b1;
                rx_en = 1'b1;
                tx_wr = 1'b1;
            end
            WAIT_TO_START: begin
                tx_en = 1'b1;
                rx_en = 1'b1;
                tx_wr = 1'b0;
            end
            WAIT_TO_END: begin
                tx_en = 1'b1;
                rx_en = 1'b1;
                tx_wr = 1'b0;
            end
            END_STATE: begin
                tx_en = 1'b1;
                rx_en = 1'b1;
                tx_wr = 1'b0;
            end
            default: begin
                tx_en = 1'b1;
                rx_en = 1'b1;
                tx_wr = 1'b0;
            end
        endcase
    end

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        #300 reset = 1'b1;
        #300 reset = 1'b0;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule