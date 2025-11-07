
module router_top(clock, resetn, read_enb_0, read_enb_1, read_enb_2, data_in, pkt_valid, data_out_0, data_out_1, data_out_2, valid_out_0, valid_out_1, valid_out_2, error, busy);
    input clock, resetn, read_enb_0, read_enb_1, read_enb_2, pkt_valid;
    input [7:0] data_in;
    output [7:0] data_out_0, data_out_1, data_out_2;
    output valid_out_0, valid_out_1, valid_out_2, error, busy;

    wire [2:0] write_enb;
    wire [7:0] dout;
    wire detect_add;
    wire write_enb_reg;

    wire fifo_full;
    wire parity_done;
    wire soft_reset_0;
    wire soft_reset_1;
    wire soft_reset_2;
    wire low_pkt_valid;
    wire ld_state;
    wire laf_state;
    wire full_state;
    wire rst_int_reg;
    wire lfd_state;
    wire full_0;
    wire full_1;
    wire full_2;
    wire empty_0;
    wire empty_1;
    wire empty_2;
    
                    
    router_fsm fsm(clock, 
                   resetn, 
                   pkt_valid, 
                   parity_done, 
                   data_in[1:0], 
                   soft_reset_0, 
                   soft_reset_1,
                   soft_reset_2, 
                   fifo_full, 
                   low_pkt_valid, 
                   busy, 
                   detect_add, 
                   ld_state, 
                   laf_state, 
                   full_state, 
                   write_enb_reg, 
                   rst_int_reg, 
                   lfd_state, 
                   empty_0, 
                   empty_1, 
                   empty_2);

    router_reg register(clock, 
                        resetn, 
                        pkt_valid, 
                        data_in, 
                        fifo_full, 
                        rst_int_reg, 
                        detect_add, 
                        ld_state, 
                        laf_state, 
                        full_state, 
                        lfd_state, 
                        parity_done, 
                        low_pkt_valid, 
                        error, 
                        dout);
                        
    router_sync sync(detect_add, 
                    data_in[1:0], 
                    write_enb_reg, 
                    clock, 
                    resetn, 
                    read_enb_0, 
                    read_enb_1, 
                    read_enb_2, 
                    empty_0, 
                    empty_1, 
                    empty_2, 
                    full_0, 
                    full_1, 
                    full_2, 
                    valid_out_0,
                    valid_out_1,
                    valid_out_2, 
                    soft_reset_0,
                    soft_reset_1,
                    soft_reset_2, 
                    write_enb, 
                    fifo_full);
                    
    router_fifo fifo_0(clock, 
                       resetn, 
                       write_enb[0], 
                       soft_reset_0, 
                       read_enb_0, 
                       dout, 
                       lfd_state, 
                       empty_0, 
                       data_out_0, 
                       full_0);  

    router_fifo fifo_1(clock, 
                       resetn, 
                       write_enb[1], 
                       soft_reset_1, 
                       read_enb_1, 
                       dout, 
                       lfd_state, 
                       empty_1, 
                       data_out_1, 
                       full_1);
 
    router_fifo fifo_2(clock, 
                       resetn, 
                       write_enb[2], 
                       soft_reset_2, 
                       read_enb_2, 
                       dout, 
                       lfd_state, 
                       empty_2, 
                       data_out_2, 
                       full_2);
                                  
endmodule
