`timescale 1ns/10ps
module value_reader_tb;
reg clk, reset;
reg command_done;
reg [7:0] received_data;
wire [11:0] x_avg, y_avg, z_avg;
wire [18:0] t_avg;
wire send, values_ready;
wire [7:0] command, address, data;

reg [2:0] reset_counter;
reg [2:0] read_counter;
reg [3:0] done_counter;

value_reader uut (
    .clk(clk),
    .reset(reset),
    .command_done(command_done),
    .received_data(received_data),
    .x_avg(x_avg),
    .y_avg(y_avg),
    .z_avg(z_avg),
    .t_avg(t_avg),
    .values_ready(values_ready),
    .send(send),
    .command(command),
    .address(address),
    .data(data)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    clk = 1'b0;
    reset = 1'b0;
    command_done = 1'b0;
    received_data = 8'b0;
    #300 reset = 1'b1;
    #105 reset = 1'b0;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        command_done <= 1'b0;
    end else if (done_counter == 4'd9) begin
        command_done <= 1'b1;
    end else begin
        command_done <= 1'b0;
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        done_counter <= 4'b0;
    end else if (done_counter == 4'd9 || !send) begin
        done_counter <= 4'b0;
    end else begin
        done_counter <= done_counter + 4'b1;
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        read_counter <= 3'b0;
    end else if (command_done && reset_counter == 2'd3) begin
        read_counter <= read_counter + 3'b1;
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        reset_counter <= 2'b0;
    end else if (command_done && reset_counter != 2'd3) begin
        reset_counter <= reset_counter + 2'b1;
    end
end

always @(read_counter) begin
    case (read_counter)
        3'b000: received_data <= 8'b11100111;
        3'b001: received_data <= 8'b00000010;
        3'b010: received_data <= 8'b10010110;
        3'b011: received_data <= 8'b00000100;
        3'b100: received_data <= 8'b11111000;
        3'b101: received_data <= 8'b00000011;
        3'b110: received_data <= 8'b11000000;
        3'b111: received_data <= 8'b00000001;
    endcase
end

endmodule