module sprite_controller #(
    parameter X_BOUNDARY = 8'd127,
    parameter Y_BOUNDARY = 8'd95,
    parameter X_POS = 8'd38,
    parameter Y_POS = 8'd38
) (
    clk,
    reset,
    edit_mode,
    accel_mode,
    up_ctrl,
    down_ctrl,
    left_ctrl,
    right_ctrl,
    x_accel,
    y_accel,
    frame_end,
    start_pos,
    end_pos,
    r,
    g,
    b
);
    localparam WIDTH = 8'd51;
    localparam HEIGHT = 8'd22;
    localparam START_POS = (X_BOUNDARY + 1) * Y_POS + X_POS;
    localparam END_POS = START_POS + 2_739;
    localparam FRAME_INTERVAL = 2'b10;

    input clk, reset, edit_mode, accel_mode;
    input up_ctrl, down_ctrl, left_ctrl, right_ctrl;
    input frame_end;
    input signed [11:0] x_accel, y_accel;
    output reg signed [13:0] start_pos, end_pos;
    output wire r, g, b;

    reg [1:0] frame_counter;
    reg [2:0] color;
    wire up_collision, down_collision, left_collision, right_collision;
    reg signed [7:0] x_pos, y_pos;
    reg signed [7:0] x_velocity, y_velocity;
    wire signed [14:0] x_step, y_step;
    wire signed [7:0] x_accel_scaled, y_accel_scaled;
    wire signed [7:0] down_remainder, right_remainder;

    assign r = color[0];
    assign g = color[1];
    assign b = color[2];
    assign x_accel_scaled = x_accel >>> 4'd8;
    assign y_accel_scaled = y_accel >>> 4'd8;
    assign x_step = right_collision ? right_remainder : (left_collision ? -x_pos : x_velocity);
    assign y_step = (down_collision ? down_remainder : (up_collision ? -y_pos : y_velocity)) << 7;

    assign down_remainder = -(y_pos + HEIGHT - 8'b1 - Y_BOUNDARY);
    assign right_remainder = -(x_pos + WIDTH - 8'b1 - X_BOUNDARY);
    assign up_collision = y_pos + y_velocity <= 8'b0;
    assign down_collision = down_remainder <= y_velocity;
    assign left_collision = x_pos + x_velocity <= 8'b0;
    assign right_collision = right_remainder <= x_velocity;
    
    always @(posedge clk) begin
        if (reset) begin
            frame_counter <= 2'b0;
        end else if (frame_end) begin
            if (frame_counter == FRAME_INTERVAL) begin
                frame_counter <= 2'b0;
            end else begin
                frame_counter <= frame_counter + 2'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            color <= 3'b001;
        end else if ((frame_counter == FRAME_INTERVAL && frame_end) && (up_collision || down_collision || right_collision || left_collision)) begin // If any collision is about to happen
            if (color == 3'b111) begin // Don't use black color
                color <= 3'b001;
            end else begin
                color <= color + 3'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            x_velocity <= 8'd1;
        end else if (frame_counter == FRAME_INTERVAL && frame_end) begin
            if (!accel_mode && !edit_mode) begin
                if (right_collision) begin
                    x_velocity <= -8'd1;
                end else if (left_collision) begin
                    x_velocity <= 8'd1;
                end else if (x_velocity != 8'd1 && x_velocity != -8'd1)begin
                    x_velocity <= x_velocity[7] ? -8'd1 : 8'd1;
                end
            end else if (accel_mode) begin
                if ((right_collision && x_accel_scaled >= 0) || (left_collision && x_accel_scaled <= 0)) begin
                    x_velocity <= 8'd0;
                end else begin
                    x_velocity <= x_accel_scaled;
                end
            end else begin
                if ((right_ctrl && right_collision) || (left_ctrl && left_collision)) begin
                    x_velocity <= 8'd0;
                end else if (right_ctrl) begin
                    x_velocity <= 8'd1;
                end else if (left_ctrl) begin
                    x_velocity <= -8'd1;
                end else begin
                    x_velocity <= 8'd0;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            y_velocity <= 8'd1;
        end else if (frame_counter == FRAME_INTERVAL && frame_end) begin 
            if (!accel_mode && !edit_mode) begin
                if (down_collision) begin
                    y_velocity <= -8'd1;
                end else if (up_collision) begin
                    y_velocity <= 8'd1;
                end else if (y_velocity != 8'd1 && y_velocity != -8'd1)begin
                    y_velocity <= y_velocity[7] ? -8'd1 : 8'd1;
                end
            end else if (accel_mode) begin
                if ((down_collision && y_accel_scaled >= 0) || (up_collision && y_accel_scaled <= 0)) begin
                    y_velocity <= 8'd0;
                end else begin
                    y_velocity <= y_accel_scaled;
                end
            end else begin
                if ((down_collision && down_ctrl) || (up_collision && up_ctrl)) begin
                    y_velocity <= 8'd0;
                end else if (down_ctrl) begin
                    y_velocity <= 8'd1;
                end else if (up_ctrl) begin
                    y_velocity <= -8'd1;
                end else begin
                    y_velocity <= 8'd0;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            start_pos <= START_POS;
            end_pos <= END_POS;
            x_pos <= X_POS;
            y_pos <= Y_POS;
        end else if (frame_counter == FRAME_INTERVAL && frame_end) begin
            if (right_collision) begin
                x_pos <= x_pos + right_remainder;
            end else if (left_collision) begin
                x_pos <= 8'b0;
            end else begin
                x_pos <= x_pos + x_velocity;
            end

            if (down_collision) begin
                y_pos <= y_pos + down_remainder;
            end else if (up_collision) begin
                y_pos <= 8'b0;
            end else begin
                y_pos <= y_pos + y_velocity;
            end

            start_pos <= start_pos + x_step + y_step;
            end_pos <= end_pos + x_step + y_step;
        end
    end
    
endmodule