module spi_master (
    clk,
    reset,
    sclk,
    ss,
    mosi,
    miso,
    enable,
    data_ready,
    data_to_transmit,
    received_data
);

localparam SHIFT_ON = 5'd8;
localparam SAMPLE_ON = 5'd18;
localparam DISABLE_ON = 5'd11;

input clk, reset, enable;
output reg data_ready;
input [7:0] data_to_transmit;
output reg [7:0] received_data;

/* SCLK signals */
output wire sclk;
wire sclk_started;
reg [4:0] sclk_counter;

/* Communication related */
input miso;
output reg mosi;
reg [7:0] shift_register;
reg [2:0] bit_counter;
 
/* FSM states and outputs */
parameter IDLE = 3'd0;
parameter LOAD = 3'd1;
parameter SAMPLE = 3'd2;
parameter SAMPLE_WAIT = 3'd3;
parameter SHIFT = 3'd4;
parameter SHIFT_WAIT = 3'd5;
parameter COPY_RECEIVED = 3'd6;
parameter DONE = 3'd7;

reg [2:0] current_state, next_state;
output reg ss;
reg load_input, shift_input, sample_output;
wire copy_output;

assign copy_output = bit_counter == 3'd7 && sample_output;

clock_divider clock_divider_inst(.clk(clk), .reset(reset), .new_clk(sclk), .locked_sync(sclk_started));

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sclk_counter <= 5'd0;
    end else if (sclk_started) begin
        if (sclk_counter == 5'd19)
            sclk_counter <= 5'b0;
        else
            sclk_counter <= sclk_counter + 5'b1;
    end else begin
        sclk_counter <= 5'd0;
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) 
        bit_counter <= 3'b0;
    else if (sample_output)
        bit_counter <= bit_counter + 3'b1;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        shift_register <= 8'b0;
    else if (load_input)
        shift_register[7:1] <= data_to_transmit[6:0];
    else if (shift_input)
        shift_register <= shift_register << 1;
    else if (sample_output)
        shift_register[0] <= miso;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        mosi <= 1'b0;
    else if (load_input)
        mosi <= data_to_transmit[7];
    else if (shift_input)
        mosi <= shift_register[7];
end

always @(posedge clk or posedge reset) begin
    if (reset)
        received_data <= 8'b0;
    else if (copy_output)
        received_data <= shift_register;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

always @(current_state or enable or sclk_counter or bit_counter) begin
    case (current_state)
        IDLE: next_state = (enable && sclk_counter == SHIFT_ON) ? LOAD : IDLE;
        LOAD: next_state = (sclk_counter == SAMPLE_ON) ? SAMPLE : LOAD;
        SAMPLE: next_state = (bit_counter == 3'd7) ? COPY_RECEIVED : SAMPLE_WAIT;
        SAMPLE_WAIT: next_state = (sclk_counter == SHIFT_ON) ? SHIFT : SAMPLE_WAIT;
        SHIFT: next_state = SHIFT_WAIT;
        SHIFT_WAIT: next_state = (sclk_counter == SAMPLE_ON) ? SAMPLE : SHIFT_WAIT;
        COPY_RECEIVED: next_state = DONE;
        DONE: begin
            if (enable && sclk_counter == SHIFT_ON) begin
                next_state = LOAD;
            end else if (sclk_counter == DISABLE_ON) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(current_state) begin
    case (current_state)
        IDLE: begin
            ss = 1;
            load_input = 0;
            shift_input = 0;
            sample_output = 0;
            data_ready = 0;
        end
        LOAD: begin
            ss = 0;
            load_input = 1;
            shift_input = 0;
            sample_output = 0;
            data_ready = 0;
        end
        SAMPLE: begin
            ss = 0;
            load_input = 0;
            shift_input = 0;
            sample_output = 1;
            data_ready = 0;
        end
        SHIFT: begin
            ss = 0;
            load_input = 0;
            shift_input = 1;
            sample_output = 0;
            data_ready = 0;
        end
        COPY_RECEIVED: begin
            ss = 0;
            load_input = 0;
            shift_input = 0;
            sample_output = 0;
            data_ready = 1;
        end
        DONE: begin
            ss = 0;
            load_input = 0;
            shift_input = 0;
            sample_output = 0;
            data_ready = 0;
        end
        default: begin 
            ss = 0;
            load_input = 0;
            shift_input = 0;
            sample_output = 0;
            data_ready = 0;
        end
    endcase
end

    
endmodule