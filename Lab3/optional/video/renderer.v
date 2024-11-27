module renderer (
    clk,
    reset,
    frame_end,
    write_enable,
    write_address,
    write_data
);

    parameter WAIT = 1'b0;
    parameter WRITE = 1'b1;
    parameter X_BOUNDARY = 7'd127;
    parameter Y_BOUNDARY = 7'd96;

    input clk, reset;
    input frame_end;
    output reg [13:0] write_address;
    output reg [2:0] write_data;
    output reg write_enable;

    reg current_state, next_state;
    reg [13:0] next_frame_address [11:0];
    wire frame_out [11:0];
    reg [3:0] frame_counter;

    for (integer i = 0; i < 12; i = i + 1) begin
        vram vram_inst(.clk(clk), .reset(reset), .read_address(next_frame_address[i]), .out(frame_out[i]));
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frame_counter <= 4'b0;
        end else if (frame_end) begin
            if (frame_counter == 4'd11) begin
                frame_counter <= 4'b0;
            end else begin
                frame_counter <= frame_counter + 4'b1;
            end
        end
    end

    always @(write_enable or write_address) begin
        if (!write_enable) begin
            next_frame_address[frame_counter] = 14'd0;
        end else begin
            next_frame_address[frame_counter] = write_address + 14'b1;
        end
    end

    always @(write_enable or write_address) begin
        if (!write_enable) begin
            write_data = 3'b0;
        end else begin
            write_data = frame_out[frame_counter];
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            write_address <= 14'b0;
        end else if (!write_enable) begin
            write_address <= 14'b0;
        end else begin
            write_address <= write_address + 14'b1;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            current_state <= WRITE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or write_address or frame_end) begin
        case (current_state)
            WAIT: next_state = frame_end ? WRITE : WAIT;
            WRITE: next_state = write_address == 14'd11_775 ? WAIT : WRITE; 
            default: next_state = WAIT; 
        endcase
    end

    always @(current_state) begin
        case (current_state)
            WAIT: write_enable = 1'b0;
            WRITE: write_enable = 1'b1;
            default: write_enable = 1'b0; 
        endcase
    end

    
endmodule