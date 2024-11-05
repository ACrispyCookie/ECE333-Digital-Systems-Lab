module receiver_fsm(clk, reset, rx_en, rxD, sample_done, previous_bit, current_bit, rx_start, rx_busy, rx_busy_data, rx_ferror, rx_parity_check);
    input clk, reset, rx_en, rxD, sample_done, previous_bit, current_bit;
    output reg rx_start, rx_busy, rx_busy_data, rx_ferror, rx_parity_check;

    reg [3:0] current_state, next_state;

    localparam DISABLED = 4'd0;
    localparam IDLE = 4'd1;
    localparam START_BIT = 4'd2;
    localparam BIT_0 = 4'd3;
    localparam BIT_1 = 4'd4;
    localparam BIT_2 = 4'd5;
    localparam BIT_3 = 4'd6;
    localparam BIT_4 = 4'd7;
    localparam BIT_5 = 4'd8;
    localparam BIT_6 = 4'd9;
    localparam BIT_7 = 4'd10;
    localparam PARITY_BIT = 4'd11;
    localparam STOP_BIT = 4'd12;
    localparam COMPLETED = 4'd13;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            current_state <= DISABLED;
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or rx_en or rxD or sample_done) begin
        case (current_state)
            DISABLED: begin
                next_state = rx_en ? IDLE : DISABLED;
            end
            IDLE: begin
                if (!rx_en) begin
                    next_state = DISABLED;
                end else if (!rxD) begin
                    next_state = START_BIT;
                end else begin
                    next_state = IDLE;
                end
            end
            COMPLETED: begin
                if (!rx_en) begin
                    next_state = DISABLED;
                end else if (!rxD) begin
                    next_state = START_BIT;
                end else begin
                    next_state = COMPLETED;
                end
            end
            START_BIT: begin
                next_state = sample_done ? BIT_0 : START_BIT;
            end
            BIT_0: begin
                next_state = sample_done ? BIT_1 : BIT_0;
            end
            BIT_1: begin
                next_state = sample_done ? BIT_2 : BIT_1;
            end
            BIT_2: begin
                next_state = sample_done ? BIT_3 : BIT_2;
            end
            BIT_3: begin
                next_state = sample_done ? BIT_4 : BIT_3;
            end
            BIT_4: begin
                next_state = sample_done ? BIT_5 : BIT_4;
            end
            BIT_5: begin
                next_state = sample_done ? BIT_6 : BIT_5;
            end
            BIT_6: begin
                next_state = sample_done ? BIT_7 : BIT_6;
            end
            BIT_7: begin
                next_state = sample_done ? PARITY_BIT : BIT_7;
            end
            PARITY_BIT: begin
                next_state = sample_done ? STOP_BIT : PARITY_BIT;
            end
            STOP_BIT: begin
                next_state = sample_done ? IDLE : STOP_BIT;
            end
            default: begin
                next_state = DISABLED;
            end
        endcase
    end

    always @(current_state or previous_bit or current_bit) begin
        case (current_state)
            DISABLED:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = 1'b0;
                rx_parity_check = 1'b0;
                rx_busy = 1'b0;
                rx_busy_data = 1'b0;
            IDLE:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = 1'b0;
                rx_parity_check = 1'b0;
                rx_busy = 1'b0;
                rx_busy_data = 1'b0;
            COMPLETED:
                rx_start = 1'b0;
                rx_completed = 1'b1;
                rx_ferror = 1'b0;
                rx_parity_check = 1'b0;
                rx_busy = 1'b0;
                rx_busy_data = 1'b0;
            START_BIT:
                rx_start = 1'b1;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b0;
            BIT_0:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b1;
            BIT_1:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b1;
            BIT_2:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b1;
            BIT_3:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b1;
            BIT_4:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b1;
            BIT_5:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b1;
            BIT_6:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b1;
            BIT_7:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b1;
            PARITY_BIT:
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b1;
                rx_busy = 1'b1;
                rx_busy_data = 1'b0;
            STOP_BIT: 
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = previous_bit != current_bit;
                rx_parity_check = 1'b0;
                rx_busy = 1'b1;
                rx_busy_data = 1'b0;
            default: 
                rx_start = 1'b0;
                rx_completed = 1'b0;
                rx_ferror = 1'b0;
                rx_parity_check = 1'b0;
                rx_busy = 1'b0;
                rx_busy_data = 1'b0;
        endcase
    end
    
endmodule