module adxl362_driver (
    clk,
    reset,
    sclk,
    miso,
    id,
    id2,
    // x_raw,
    // y_raw,
    // z_raw,
    // t_raw,
    raw_values_ready
);

    parameter WAIT_DONE = 50000;

    /* FSM states */
    parameter RESET = 3'd1;
    parameter WAIT_RESET = 3'd2;
    parameter REQ_ID = 3'd3;
    parameter REQ_ID2 = 3'd4;

    /* FSM signals */
    reg [2:0] current_state, next_state;
    reg [15:0] wait_counter;
    reg start, wait_reset, id_loading, id2_loading;
    reg [7:0] command, address, data_to_transmit; 
    wire load_next;
    wire [7:0] received_data;

    /* Inputs/Outputs */
    input clk, reset, miso;
    output wire sclk;
    // output reg [] x_raw, y_raw, z_raw;
    // output reg [] t_raw;
    output reg [7:0] id, id2;
    output reg raw_values_ready;

    command_sender command_sender_inst(.clk(clk), .reset(reset), .sclk(sclk), .miso(miso), .start(start), .load_next(load_next), .command(command), 
    .address(address), .transmit_data(data_to_transmit), .received_data(received_data));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id <= 8'b0;
        end else if (load_next && id_loading) begin
            id <= received_data;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id2 <= 8'b0;
        end else if (load_next && id2_loading) begin
            id2 <= received_data;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wait_counter <= 16'b0;
        end else if (wait_reset) begin
            wait_counter <= wait_counter + 16'b1;
        end else begin
            wait_counter <= 16'b0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RESET;
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or load_next or wait_counter) begin
        case (current_state)
            RESET: next_state = load_next ? WAIT_RESET : RESET;
            WAIT_RESET: next_state = wait_counter == WAIT_DONE ? REQ_ID : WAIT_RESET;
            REQ_ID: next_state = load_next ? REQ_ID2 : REQ_ID;
            REQ_ID2: next_state = load_next ? REQ_ID : REQ_ID2;
            default: next_state = RESET;
        endcase
    end

    always @(current_state) begin
        case (current_state)
            RESET: begin
                start = 1'b1;
                wait_reset = 1'b0;
                command = 7'h0a;
                address = 7'h1f;
                data_to_transmit = 7'h52;
                id_loading = 1'b0;
                id2_loading = 1'b0;
            end
            WAIT_RESET:  begin
                start = 1'b0;
                wait_reset = 1'b1;
                command = 7'h0;
                address = 7'h0;
                data_to_transmit = 7'h0;
                id_loading = 1'b0;
                id2_loading = 1'b0;
            end
            REQ_ID: begin
                start = 1'b1;
                wait_reset = 1'b0;
                command = 7'h0b;
                address = 7'h0;
                data_to_transmit = 7'h0;
                id_loading = 1'b1;
                id2_loading = 1'b0;
            end
            REQ_ID2: begin
                start = 1'b1;
                wait_reset = 1'b0;
                command = 7'h0b;
                address = 7'h01;
                data_to_transmit = 7'h0;
                id_loading = 1'b0;
                id2_loading = 1'b1;
            end
            default: begin
                start = 1'b0;
                wait_reset = 1'b0;
                command = 7'h0;
                address = 7'h0;
                data_to_transmit = 7'h0;
                id_loading = 1'b0;
                id2_loading = 1'b0;
            end
        endcase
    end

endmodule