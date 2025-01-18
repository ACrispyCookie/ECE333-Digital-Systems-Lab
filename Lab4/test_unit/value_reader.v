module value_reader (
    clk,
    reset,
    simple_mode,
    no_avg,
    use_burst,
    x_binary,
    y_binary,
    z_binary,
    t_binary,
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
    localparam RESET_WAIT_TIME = 28'd50000;
    localparam READ_WAIT_TIME = 28'd3125000;
    localparam READ_SIMPLE_WAIT_TIME = 28'd200000000;

    /* FSM states */
    localparam RESET = 4'd0;
    localparam WAIT_RESET = 4'd1;
    localparam FILTER_CONTROL = 4'd2;
    localparam FILTER_DONE = 4'd3;
    localparam POWER_CONTROL = 4'd4;
    localparam INIT_DONE = 4'd5;
    localparam READ_SIMPLE = 4'd6;
    localparam READ_SIMPLE_DONE = 4'd7;
    localparam READ = 4'd8;
    localparam READ_DONE = 4'd9;
    localparam COPY_TO_AVG = 4'd10;
    localparam READ_WAIT = 4'd11;
    localparam READ_COMPLETE = 4'd12;

    /* FSM signals */
    reg [3:0] current_state, next_state;
    reg [18:0] wait_counter;
    reg [2:0] read_counter;
    reg run_wait_counter, run_read_counter, add_to_avg, read_complete;
    output reg send;
    output reg [7:0] command, address, data;

    /* Inputs/Outputs */
    input clk, reset;
    input command_done, simple_mode, no_avg, use_burst;
    input [7:0] received_data;
    output wire values_ready;
    wire avg_values_ready;

    /* Raw values */
    reg signed [11:0] x_raw, y_raw, z_raw, t_raw;

    /* Binary values */
    output wire signed [11:0] x_binary, y_binary, z_binary;
    output wire signed [18:0] t_binary;

    assign x_binary = simple_mode ? x_raw : {x_raw[11], x_raw[11:1]};
    assign y_binary = {y_raw[11], y_raw[11:1]};
    assign z_binary = {z_raw[11], z_raw[11:1]};
    assign t_binary = (t_raw << 6) + t_raw;

    /* Avg values */
    output wire signed [11:0] x_avg, y_avg, z_avg;
    output wire signed [18:0] t_avg;

    avg_calc avg_calc_inst(.clk(clk), .reset(reset), .x_binary(x_binary), .y_binary(y_binary), 
    .z_binary(z_binary), .t_binary(t_binary), .copy_values(add_to_avg), .x_avg(x_avg), .y_avg(y_avg), .z_avg(z_avg), .t_avg(t_avg),
    .ready(avg_values_ready));

    assign values_ready = (no_avg && read_complete) || avg_values_ready;

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
        end else if (run_wait_counter) begin
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

    always @(current_state or command_done or wait_counter or read_counter or use_burst or simple_mode or no_avg) begin
        case (current_state)
            RESET: next_state = command_done ? WAIT_RESET : RESET;
            WAIT_RESET: next_state = wait_counter == RESET_WAIT_TIME ? FILTER_CONTROL : WAIT_RESET;
            FILTER_CONTROL: next_state = command_done ? (~use_burst ? FILTER_DONE : POWER_CONTROL) : FILTER_CONTROL;
            FILTER_DONE: next_state = POWER_CONTROL;
            POWER_CONTROL: next_state = command_done ? INIT_DONE : POWER_CONTROL;
            INIT_DONE: next_state = simple_mode ? READ_SIMPLE : READ;

            READ_SIMPLE: begin
                if (command_done) begin
                    next_state = READ_SIMPLE_DONE;
                end else begin
                    next_state = READ_SIMPLE;
                end
            end
            READ_SIMPLE_DONE: next_state = no_avg ? READ_COMPLETE : COPY_TO_AVG;

            READ: begin
                if (command_done) begin
                    if (read_counter == T_HIGH) begin
                        next_state = no_avg ? READ_COMPLETE : COPY_TO_AVG;
                    end else if (~use_burst) begin
                        next_state = READ_DONE;
                    end else begin
                        next_state = READ;
                    end
                end else begin
                    next_state = READ;
                end
            end
            READ_DONE: next_state = READ;

            COPY_TO_AVG: next_state = READ_WAIT;
            READ_COMPLETE: next_state = READ_WAIT;

            READ_WAIT: next_state = wait_counter == (simple_mode ? READ_SIMPLE_WAIT_TIME : READ_WAIT_TIME) ? (simple_mode ? READ_SIMPLE : READ) : READ_WAIT;
            default: next_state = RESET;
        endcase
    end

    always @(current_state or read_counter) begin
        case (current_state)
            RESET: begin
                send = 1'b1;
                read_complete = 1'b0;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b0;
                command = 8'h0a;
                address = 8'h1f;
                data = 8'h52;
                add_to_avg = 1'b0;
            end
            WAIT_RESET:  begin
                send = 1'b0;
                read_complete = 1'b0;
                run_wait_counter = 1'b1;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
            FILTER_CONTROL:  begin
                send = 1'b1;
                read_complete = 1'b0;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b0;
                command = 8'h0a;
                address = 8'h2c;
                data = 8'b00_0_1_0_100;
                add_to_avg = 1'b0;
            end
            POWER_CONTROL:  begin
                send = 1'b1;
                read_complete = 1'b0;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b0;
                command = 8'h0a;
                address = 8'h2d;
                data = 8'b0_0_00_0_0_10;
                add_to_avg = 1'b0;
            end
            READ:  begin
                send = 1'b1;
                read_complete = 1'b0;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b1;
                command = 8'h0b;
                address = 8'h0e + read_counter;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
            READ_SIMPLE:  begin
                send = 1'b1;
                read_complete = 1'b0;
                run_wait_counter = 1'b0;
                run_read_counter = 1'b1;
                command = 8'h0b;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
            COPY_TO_AVG:  begin
                send = 1'b0;
                read_complete = 1'b0;
                run_wait_counter = 1'b1;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b1;
            end
            READ_COMPLETE:  begin
                send = 1'b0;
                read_complete = 1'b1;
                run_wait_counter = 1'b1;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
            READ_WAIT:  begin
                send = 1'b0;
                read_complete = 1'b0;
                run_wait_counter = 1'b1;
                run_read_counter = 1'b0;
                command = 8'h0;
                address = 8'h0;
                data = 8'h0;
                add_to_avg = 1'b0;
            end
            default: begin
                send = 1'b0;
                read_complete = 1'b0;
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