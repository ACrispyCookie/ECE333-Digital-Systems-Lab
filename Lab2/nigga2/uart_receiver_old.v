module uart_receiver(clk, reset, rx_data, baud_select, rx_en, rxD, rx_ferror, rx_perror, rx_valid, rx_valid_pulse);
    input clk, reset, rx_en, rxD;
    input [2:0] baud_select;
    output reg [7:0] rx_data;
    output reg rx_valid, rx_ferror, rx_perror;
    output wire rx_valid_pulse;

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

    reg [3:0] current_state, next_state;
    reg [3:0] sample_counter;
    reg sampled_bit, previous_bit, receiving, receiving_data_bits;
    wire rx_sample;
    wire sample_done = sample_counter == 4'b1111 && rx_sample;
    assign rx_valid_pulse = sample_counter == 4'b1111 && rx_valid && rx_sample;

    baud_controller baud_controller_rx(.clk(clk), .reset(reset), .enable(receiving), .baud_select(baud_select), .enable_sample(rx_sample));

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            current_state <= DISABLED;
        end else begin
            current_state <= next_state;
        end
    end

    always @(rx_en or rxD or sample_done or current_state) begin
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

    always @(current_state or rx_ferror or rx_perror) begin
        case (current_state)
            DISABLED:
                rx_valid = ~(rx_ferror && rx_perror);
                receiving = 1'b0;
                receiving_data_bits = 1'b0;
            IDLE:
                rx_valid = ~(rx_ferror && rx_perror);
                receiving = 1'b0;
                receiving_data_bits = 1'b0;
            START_BIT:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b0;
            BIT_0:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b1;
            BIT_1:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b1;
            BIT_2:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b1;
            BIT_3:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b1;
            BIT_4:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b1;
            BIT_5:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b1;
            BIT_6:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b1;
            BIT_7:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b1;
            PARITY_BIT:
                rx_valid = 1'b0;
                receiving = 1'b1;
                receiving_data_bits = 1'b0;
            STOP_BIT: 
                rx_valid = ~(rx_ferror && rx_perror);
                receiving = 1'b1;
                receiving_data_bits = 1'b0;
            default: 
                rx_valid = 1'b0;
                receiving = 1'b0;
                receiving_data_bits = 1'b0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_data <= 8'b00000000;
        end else if (receiving_data_bits && sample_counter == 4'd8 && rx_sample) begin
            rx_data <= {rx_data[6:0], rxD};
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || current_state == START_BIT) begin
            rx_perror <= 1'b0;
        end else if (current_state == PARITY_BIT && sample_counter == 4'd8) begin
            rx_perror <= ^rx_data ^^ rxD;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || current_state == START_BIT) begin
            rx_ferror <= 1'b0;
        end else if (receiving && sampled_bit != previous_bit) begin
            rx_ferror <= 1'b1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || !receiving) begin
            sample_counter <= 4'b0;
        end else if (rx_sample) begin
            sample_counter <= sample_counter + 4'b1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || !receiving_data_bits) begin
            previous_bit <= 1'b0;
        end else if (receiving_data_bits && sample_counter == 4'b0000 && rx_sample) begin
            previous_bit <= rxD;
        end else if (receiving_data_bits && sample_counter[0] == 1'b0 && rx_sample) begin
            previous_bit <= sampled_bit;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || !receiving_data_bits) begin
            sampled_bit <= 1'b0;
        end else if (receiving_data_bits && sample_counter[0] == 1'b0 && rx_sample) begin
            sampled_bit <= rxD;
        end
    end
    
endmodule