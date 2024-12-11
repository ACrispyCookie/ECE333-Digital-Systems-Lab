module binary_to_ascii_6 (
    binary,
    ascii_1,
    ascii_2,
    ascii_3,
    ascii_4,
    ascii_5,
    ascii_6,
    data_ready_for_transmittion
);

    localparam ZERO_ASCII = 7'd48;

    input [19:0] binary;
    output wire [7:0] ascii_1, ascii_2, ascii_3, ascii_4, ascii_5, ascii_6;
    output reg data_ready_for_transmittion;

    reg [3:0] bcd_1, bcd_2, bcd_3, bcd_4, bcd_5, bcd_6;

    assign ascii_1 = bcd_1 + ZERO_ASCII;
    assign ascii_2 = bcd_2 + ZERO_ASCII;
    assign ascii_3 = bcd_3 + ZERO_ASCII;
    assign ascii_4 = bcd_4 + ZERO_ASCII;
    assign ascii_5 = bcd_5 + ZERO_ASCII;
    assign ascii_6 = bcd_6 + ZERO_ASCII;



endmodule