module command_sender (
    clk,
    reset,
    spi_enable,
    spi_ready,
    spi_ss,
    spi_transmit_data,
    send,
    command_done,
    command,
    address,
    data
);

    /* Transmit select values */
    parameter COMMAND = 2'd1;
    parameter ADDRESS = 2'd2;
    parameter DATA = 2'd3;

    /* FSM states */
    parameter IDLE = 3'd0;
    parameter SEND_COMMAND = 3'd1;
    parameter SEND_ADDRESS = 3'd2;
    parameter SEND_DATA = 3'd3;
    parameter COMPLETED = 3'd4;
    parameter COMMAND_END = 3'd5;

    input clk, reset;
    input send, spi_ready, spi_ss;
    input [7:0] command, address, data;
    output reg [7:0] spi_transmit_data;
    output wire command_done;

    /* FSMs signals */
    output reg spi_enable;
    reg [2:0] current_state, next_state;
    reg [1:0] transmit_select;

    assign command_done = transmit_select == DATA && spi_ready;

    always @(transmit_select) begin
        case (transmit_select)
            COMMAND: spi_transmit_data = command;
            ADDRESS: spi_transmit_data = address;
            DATA: spi_transmit_data = data;
            default: spi_transmit_data = data;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or send or spi_ready or spi_ss) begin
        case (current_state)
            IDLE: next_state = send ? SEND_COMMAND : IDLE;
            SEND_COMMAND: next_state = spi_ready ? SEND_ADDRESS : SEND_COMMAND;
            SEND_ADDRESS: next_state = spi_ready ? SEND_DATA : SEND_ADDRESS;
            SEND_DATA: next_state = spi_ready ? COMPLETED : SEND_DATA;
            COMPLETED: next_state = send ? SEND_DATA : COMMAND_END;
            COMMAND_END: next_state = spi_ss ? IDLE : COMMAND_END;
            default: next_state = IDLE;
        endcase
    end

    always @(current_state) begin
        case (current_state)
            IDLE: begin
                spi_enable = 1'b0;
                transmit_select = 2'd0;
            end
            SEND_COMMAND: begin
                spi_enable = 1'b1;
                transmit_select = COMMAND;
            end
            SEND_ADDRESS: begin
                spi_enable = 1'b1;
                transmit_select = ADDRESS;
            end
            SEND_DATA: begin
                spi_enable = 1'b1;
                transmit_select = DATA;
            end
            COMPLETED: begin
                spi_enable = 1'b0;
                transmit_select = 2'd0;
            end
            COMMAND_END: begin
                spi_enable = 1'b0;
                transmit_select = 2'd0;
            end
            default: begin
                spi_enable = 1'b0;
                transmit_select = 2'd0;
            end
        endcase
    end
    
endmodule