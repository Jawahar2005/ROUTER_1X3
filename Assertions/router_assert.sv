module router_assert(input logic clock,
                  input logic resetn,
                  input logic[7:0] data_in,
                  input logic pkt_valid,
                  input logic busy,
                  input logic read_enb_0,
                  input logic read_enb_1,
                  input logic read_enb_2,
                  input logic[7:0] data_out_0,
                  input logic[7:0] data_out_1,
                  input logic[7:0] data_out_2,
                  input logic vld_out_0,
                  input logic vld_out_1,
                  input logic vld_out_2
                 );


property data_stable;
        disable iff(!resetn)
        @(posedge clock) busy |=> $stable(data_in);
endproperty

property read0;
        disable iff(!resetn)
        @(posedge clock) $rose(vld_out_0) |=> ##[0:29] read_enb_0;
endproperty

property read1;
        disable iff(!resetn)
        @(posedge clock) $rose(vld_out_1) |=> ##[0:29] read_enb_1;
endproperty

property read2;
        disable iff(!resetn)
        @(posedge clock) $rose(vld_out_2) |=> ##[0:29] read_enb_2;
endproperty

STABLE_INP_DATA:        assert property(data_stable);
VLD_READ_ENB_0:         assert property(read0);
VLD_READ_ENB_1:         assert property(read1);
VLD_READ_ENB_2:         assert property(read2);

endmodule
