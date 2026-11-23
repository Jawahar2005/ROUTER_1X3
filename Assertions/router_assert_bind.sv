
bind router_top router_assert abv(
        .clock(clock),
        .resetn(resetn),
        .data_in(data),
        .pkt_valid(packet_valid),
        .busy(busy),
        .read_enb_0(read_enb_0),
        .read_enb_1(read_enb_1),
        .read_enb_2(read_enb_2),
        .data_out_0(data_out_0),
        .data_out_1(data_out_1),
        .data_out_2(data_out_2),
        .vld_out_0(vld_out_0),
        .vld_out_1(vld_out_1),
        .vld_out_2(vld_out_2)
);
