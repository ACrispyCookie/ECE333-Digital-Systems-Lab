module command_sender (
    clk,
    reset,
    sclk,
    miso,
    start,
    command,
    address,
    transmit_data,
    received_data,
    load_next
);

    // Transmit select values
    parameter COMMAND = 2'd1;
    parameter ADDRESS = 2'd2;

    // FSM states
    parameter IDLE = 3'd0;
    parameter SEND_COMMAND = 3'd1;
    parameter SEND_ADDRESS = 3'd2;
    parameter SEND_DATA = 3'd3;
    parameter LOAD_NEXT_DATA = 3'd4;

    input clk, reset;
    input start;
    input [7:0] command, address, transmit_data;
    output wire [7:0] received_data;
    output wire load_next;
    output wire sclk, miso;

    reg [2:0] current_state, next_state;
    reg [7:0] data_to_transmit;
    reg [1:0] transmit_select;

    spi_master spi_master_inst(.clk(clk), .reset(reset), .sclk(sclk), .miso(miso), .enable(start), .ready(load_next), .data_to_transmit(data_to_transmit), .received_data(received_data));

    always @(transmit_select) begin
        case (transmit_select)
            COMMAND: data_to_transmit = command;
            ADDRESS: data_to_transmit = address; 
            default: data_to_transmit = transmit_data;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or start or load_next) begin
        case (current_state)
            IDLE: next_state = start ? SEND_COMMAND : IDLE;
            SEND_COMMAND: next_state = load_next ? SEND_ADDRESS : SEND_COMMAND;
            SEND_ADDRESS: next_state = load_next ? SEND_DATA : SEND_ADDRESS;
            SEND_DATA: next_state = load_next ? LOAD_NEXT_DATA : SEND_DATA;
            LOAD_NEXT_DATA: next_state = start ? SEND_DATA : IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(current_state) begin
        case (current_state)
            IDLE: begin
                transmit_select = 2'd0;
            end
            SEND_COMMAND: begin
                transmit_select = COMMAND;
            end
            SEND_ADDRESS: begin
                transmit_select = ADDRESS;
            end
            SEND_DATA: begin
                transmit_select = 2'd0;
            end
            LOAD_NEXT_DATA: begin
                transmit_select = 2'd0;
            end
            default: begin
                transmit_select = 2'd0;
            end
        endcase
    end
    
endmodule