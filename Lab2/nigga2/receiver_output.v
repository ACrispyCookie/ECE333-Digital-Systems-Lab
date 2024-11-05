module receiver_output(clk, reset, rx_start, rxD, sample_mid, rx_ferror_detected, rx_parity_check, rx_busy_data, rx_data, rx_perror, rx_ferror);
    input clk, reset, rx_start, rxD, sample_mid, rx_ferror_detected, rx_parity_check, rx_busy_data;
    output reg [7:0] rx_data;
    output reg rx_ferror, rx_perror;

    always @(posedge clk or posedge reset) begin
        if (reset || rx_start) begin
            rx_data <= 8'b00000000;
        end else if (rx_busy_data && sample_mid) begin
            rx_data <= {rxD, rx_data[7:1]};
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || rx_start) begin
            rx_perror <= 1'b0;
        end else if (rx_parity_check && sample_mid) begin
            rx_perror <= ^rx_data ^^ rxD;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || rx_start) begin
            rx_ferror <= 1'b0;
        end else if (rx_ferror_detected) begin
            rx_ferror <= 1'b1;
        end
    end
    
endmodule