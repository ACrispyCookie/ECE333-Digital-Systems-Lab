module value_reader (
    clk,
    reset,
    x_avg,
    y_avg,
    z_avg,
    t_avg,
    values_ready,
    send,
    command_done,
    command,
    address,
    data,
    received_data
);

    /* Read counter values */
    localparam X_LOW = 3'd0;
    localparam X_HIGH = 3'd1;
    localparam Y_LOW = 3'd2;
    localparam Y_HIGH = 3'd3;
    localparam Z_LOW = 3'd4;
    localparam Z_HIGH = 3'd5;
    localparam T_LOW = 3'd6;
    localparam T_HIGH = 3'd7;

    /* Wait counter values */
    localparam RESET_WAIT_TIME = 19'd50000;
    localparam READ_WAIT_TIME = 19'd500000;

    /* FSM states */
    localparam RESET = 3'd0;
    localparam WAIT_RESET = 3'd1;
    localparam FILTER_CONTROL = 3'd2;
    localparam POWER_CONTROL = 3'd3;
    localparam INIT_DONE = 3'd4;
    localparam READ = 3'd5;
    localparam COPY_TO_AVG = 3'd6;
    localparam READ_DONE = 3'd7;

    /* FSM signals */
    reg [3:0] current_state, next_state;
    reg [18:0] wait_counter;
    reg [2:0] read_counter;
    reg run_wait_counter, run_read_counter, add_to_avg;
    output reg send;
    output reg [7:0] command, address, data;

    /* Inputs/Outputs */
    input clk, reset;
    input command_done;
    input [7:0] received_data;
    output wire values_ready;

    /* Raw values */
    reg signed [11:0] x_raw, y_raw, z_raw, t_raw;

    /* Binary values */
    wire signed [11:0] x_binary, y_binary, z_binary;
    wire signed [18:0] t_binary;

    assign x_binary = {x_raw[11], x_raw[11:1]};
    assign y_binary = {y_raw[11], y_raw[11:1]};
    assign z_binary = {z_raw[11], z_raw[11:1]};
    assign t_binary = (t_raw << 6) + t_raw;

    /* Avg values */
    output wire signed [11:0] x_avg, y_avg, z_avg;
    output wire signed [18:0] t_avg;

    avg_calc avg_calc_inst(.clk(clk), .reset(reset), .x_binary(x_binary), .y_binary(y_binary), 
    .z_binary(z_binary), .t_binary(t_binary), .copy_values(add_to_avg), .x_avg(x_avg), .y_avg(y_avg), .z_avg(z_avg), .t_avg(t_avg),
    .ready(values_ready));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_raw <= 12'b0;
        end else if (command_done) begin
            if (read_counter == X_LOW)
                x_raw[7:0] <= received_data;
            else if (read_counter == X_HIGH)
                x_raw[11:8] <= received_data[3:0];
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y_raw <= 12'b0;
        end else if (command_done) begin
            if (read_counter == Y_LOW)
                y_raw[7:0] <= received_data;
            else if (read_counter == Y_HIGH)
                y_raw[11:8] <= received_data[3:0];
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            z_raw <= 12'b0;
        end else if (command_done) begin
            if (read_counter == Z_LOW)
                z_raw[7:0] <= received_data;
            else if (read_counter == Z_HIGH)
                z_raw[11:8] <= received_data[3:0];
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            t_raw <= 12'b0;
        end else if (command_done) begin
            if (read_counter == T_LOW)
                t_raw[7:0] <= received_data;
            else if (read_counter == T_HIGH)
                t_raw[11:8] <= received_data[3:0];
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wait_counter <= 19'b0;
        end else if (run_wait_counter) begin
            wait_counter <= wait_counter + 19'b1;
        end else begin
            wait_counter <= 19'b0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            read_counter <= 3'b0;
        end else if (run_read_counter && command_done) begin
            read_counter <= read_counter + 3'b1;
        end else if (~run_read_counter) begin
            read_counter <= 3'b0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RESET;
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or command_done or wait_counter or read_counter) begin
        case (current_state)
            RESET: next_state = command_done ? WAIT_RESET : RESET;
            WAIT_RESET: next_state = wait_counter == RESET_WAIT_TIME ? FILTER_CONTROL : WAIT_RESET;
            FILTER_CONTROL: next_state = command_done ? POWER_CONTROL : FILTER_CONTROL;
            POWER_CONTROL: next_state = command_done ? INIT_DONE : POWER_CONTROL;
            INIT_DONE: next_state = READ;
            READ: next_state = (command_done && read_counter == T_HIGH) ? COPY_TO_AVG : READ;
            COPY_TO_AVG: next_state = READ_DONE;
            READ_DONE: next_state = wait_counter == READ_WAIT_TIME ? READ : READ_DONE;
            default: next_state = RESET;
        endcase
    end

    always @(current_state) begin
        case (current_state)
            RESET: begin
                send = 1'b1;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b0;
                command = 8'h0a;
                address = 8'h1f;
                data = 8'h52;
                add_to_avg = 1'b0;
            end
            WAIT_RESET:  begin
                send = 1'b0;
                run_wait_counter = 1'b1;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
            FILTER_CONTROL:  begin
                send = 1'b1;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b0;
                command = 8'h0a;
                address = 8'h2c;
                data = 8'b00_0_1_0_100;
                add_to_avg = 1'b0;
            end
            POWER_CONTROL:  begin
                send = 1'b1;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'b0_0_00_0_0_10;
                add_to_avg = 1'b0;
            end
            INIT_DONE:  begin
                send = 1'b0;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
            READ:  begin
                send = 1'b1;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b1;
                command = 8'h0b;
                address = 8'h0e;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
            COPY_TO_AVG:  begin
                send = 1'b0;
                run_wait_counter = 1'b1;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b1;
            end
            READ_DONE:  begin
                send = 1'b0;
                run_wait_counter = 1'b1;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
            default: begin
                send = 1'b0;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
        endcase
    end

endmodule