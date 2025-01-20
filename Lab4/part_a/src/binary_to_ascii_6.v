module binary_to_ascii_6 (
    clk,
    reset,
    binary,
    start,
    ascii_1,
    ascii_2,
    ascii_3,
    ascii_4,
    ascii_5,
    ascii_6,
    is_negative,
    ready
);

    localparam BINARY_WIDTH = 19;
    localparam ZERO_ASCII = 8'd48;
    localparam WAIT_FOR_NEW_CYCLES = 3'd4;
    // FSM states
    localparam IDLE = 3'd0;
    localparam WAIT_FOR_NEW = 3'd1;
    localparam COPY = 3'd2;
    localparam SHIFT = 3'd3;
    localparam ADD = 3'd4;
    localparam READY = 3'd5;

    input clk, reset;
    input [BINARY_WIDTH-1:0] binary;
    input start;
    output wire [7:0] ascii_1, ascii_2, ascii_3, ascii_4, ascii_5, ascii_6;
    output reg ready, is_negative;

    reg [3:0] bcd_1, bcd_2, bcd_3, bcd_4, bcd_5, bcd_6;
    reg [2:0] current_state, next_state;
    reg [4:0] shift_counter;
    reg [2:0] wait_counter;
    reg [BINARY_WIDTH-2:0] binary_reg;
    reg shift_enabled, adding_enabled, copy_binary, wait_for_new;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wait_counter <= 3'b0;
        end else if (wait_for_new && wait_counter != WAIT_FOR_NEW_CYCLES) begin
            wait_counter <= wait_counter + 3'b1;
        end else if (copy_binary) begin
            wait_counter <= 3'b0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            binary_reg <= 20'd0;
            is_negative <= 1'b0;
        end else if (copy_binary) begin
            binary_reg <= binary[BINARY_WIDTH-1] ? ~binary[BINARY_WIDTH-2:0] + 1 : binary[BINARY_WIDTH-2:0];
            is_negative <= binary[BINARY_WIDTH-1];
        end else if (shift_enabled) begin
            binary_reg <= binary_reg << 1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bcd_1 <= 4'd0;
            bcd_2 <= 4'd0;
            bcd_3 <= 4'd0;
            bcd_4 <= 4'd0;
            bcd_5 <= 4'd0;
            bcd_6 <= 4'd0;
        end else if (copy_binary) begin
            bcd_1 <= 4'd0;
            bcd_2 <= 4'd0;
            bcd_3 <= 4'd0;
            bcd_4 <= 4'd0;
            bcd_5 <= 4'd0;
            bcd_6 <= 4'd0;
        end else if (adding_enabled) begin
            bcd_1 <= bcd_1 >= 5 ? bcd_1 + 4'd3 : bcd_1;
            bcd_2 <= bcd_2 >= 5 ? bcd_2 + 4'd3 : bcd_2;
            bcd_3 <= bcd_3 >= 5 ? bcd_3 + 4'd3 : bcd_3;
            bcd_4 <= bcd_4 >= 5 ? bcd_4 + 4'd3 : bcd_4;
            bcd_5 <= bcd_5 >= 5 ? bcd_5 + 4'd3 : bcd_5;
            bcd_6 <= bcd_6 >= 5 ? bcd_6 + 4'd3 : bcd_6;
        end else if (shift_enabled) begin
            {bcd_1, bcd_2, bcd_3, bcd_4, bcd_5, bcd_6} <= {bcd_1, bcd_2, bcd_3, bcd_4, bcd_5, bcd_6} << 1 | binary_reg[BINARY_WIDTH-2];
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_counter <= 5'd0;
        end else if (shift_enabled) begin
            shift_counter <= shift_counter + 5'b1;
        end else if (!adding_enabled) begin
            shift_counter <= 5'd0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state; 
    end

    always @(current_state or start or shift_counter or wait_counter) begin
        case (current_state)
            IDLE: next_state = start ? WAIT_FOR_NEW : IDLE;
            WAIT_FOR_NEW: next_state = (wait_counter == WAIT_FOR_NEW_CYCLES) ? COPY : WAIT_FOR_NEW;
            COPY: next_state = SHIFT;
            SHIFT: next_state = (shift_counter == BINARY_WIDTH-2) ? READY : ADD;
            ADD: next_state = SHIFT;
            READY: next_state = IDLE; 
            default: next_state = IDLE;
        endcase
    end

    always @(current_state) begin
        case (current_state)
            IDLE: begin
                copy_binary = 1'b0;
                shift_enabled = 1'b0;
                adding_enabled = 1'b0;
                wait_for_new = 1'b1;
                ready = 1'b0;
            end
            WAIT_FOR_NEW: begin
                copy_binary = 1'b0;
                shift_enabled = 1'b0;
                adding_enabled = 1'b0;
                wait_for_new = 1'b1;
                ready = 1'b0;
            end
            COPY: begin
                copy_binary = 1'b1;
                shift_enabled = 1'b0;
                adding_enabled = 1'b0;
                wait_for_new = 1'b0;
                ready = 1'b0;
            end
            SHIFT: begin
                copy_binary = 1'b0;
                shift_enabled = 1'b1;
                adding_enabled = 1'b0;
                wait_for_new = 1'b0;
                ready = 1'b0;
            end
            ADD: begin
                copy_binary = 1'b0;
                shift_enabled = 1'b0;
                adding_enabled = 1'b1;
                wait_for_new = 1'b0;
                ready = 1'b0;
            end
            READY: begin
                copy_binary = 1'b0;
                shift_enabled = 1'b0;
                adding_enabled = 1'b0;
                wait_for_new = 1'b0;
                ready = 1'b1;
            end
            default: begin
                copy_binary = 1'b0;
                shift_enabled = 1'b0;
                adding_enabled = 1'b0;
                wait_for_new = 1'b0;
                ready = 1'b0;
            end
        endcase
    end

    assign ascii_1 = bcd_1 + ZERO_ASCII;
    assign ascii_2 = bcd_2 + ZERO_ASCII;
    assign ascii_3 = bcd_3 + ZERO_ASCII;
    assign ascii_4 = bcd_4 + ZERO_ASCII;    
    assign ascii_5 = bcd_5 + ZERO_ASCII;    
    assign ascii_6 = bcd_6 + ZERO_ASCII;    

endmodule