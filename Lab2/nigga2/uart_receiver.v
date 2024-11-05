module uart_receiver(clk, reset, baud_select, rx_en, rxD, rx_data, rx_ferror, rx_perror, rx_valid);
    input clk, reset, rx_en, rxD;
    input [2:0] baud_select;
    output wire [7:0] rx_data;
    output wire rx_valid, rx_ferror, rx_perror;

    wire rx_start, rx_busy, rx_busy_data, rx_ferror_detected, rx_parity_check, rx_completed;
    wire rx_sample, sample_mid, sample_done, previous_bit, current_bit;
    assign rx_valid = rx_completed && ~rx_perror && ~rx_ferror;

    baud_controller baud_controller_inst(.clk(clk), .reset(reset), .enable(rx_busy), .baud_select(baud_select), .enable_sample(rx_sample));
    
    receiver_sampler receiver_sampler_inst(.clk(clk), .reset(reset), .counter_enable(rx_busy), .sampler_enable(rx_busy_data), .sample_pulse(rx_sample),
    .data(rxD), .sample_mid(sample_mid), .sample_done(sample_done), .previous_bit(previous_bit), .current_bit(current_bit));
    
    receiver_fsm receiver_fsm_inst(.clk(clk), .reset(reset), .rx_en(rx_en), .rxD(rxD), .sample_done(sample_done), .previous_bit(previous_bit), .current_bit(current_bit),
    .rx_start(rx_start), .rx_busy(rx_busy), .rx_busy_data(rx_busy_data), .rx_ferror(rx_ferror_detected), .rx_parity_check(rx_parity_check), .rx_completed(rx_completed));
    
    receiver_output receiver_output_inst(.clk(clk), .reset(reset), .rx_start(rx_start), .rxD(rxD), .sample_mid(sample_mid), .rx_ferror_detected(rx_ferror_detected),
    .rx_parity_check(rx_parity_check), .rx_busy_data(rx_busy_data), .rx_data(rx_data), .rx_perror(rx_perror), .rx_ferror(rx_ferror));
    
endmodule