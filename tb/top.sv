module top;

        import test_pkg::*;
        import uvm_pkg::*;

        bit clock;

        always #5 clock = ~clock;

        router_if in(clock);
        router_if in0(clock);
        router_if in1(clock);
        router_if in2(clock);

        router_top DUV(.clock(clock),
                       .resetn(in.reset_n),
                       .read_enb_0(in0.read_enb),
                       .read_enb_1(in1.read_enb),
                       .read_enb_2(in2.read_enb),
                       .packet_valid(in.pkt_valid),
                       .data(in.data_in),
                       .data_out_0(in0.data_out),
                       .data_out_1(in1.data_out),
                       .data_out_2(in2.data_out),
                       .vld_out_0(in0.valid_out),
                       .vld_out_1(in1.valid_out),
                       .vld_out_2(in2.valid_out),
                       .err(in.error),
                       .busy(in.busy));

        initial begin
                uvm_config_db #(virtual router_if)::set(null,"*","vif",in);
                uvm_config_db #(virtual router_if)::set(null,"*","vif0",in0);
                uvm_config_db #(virtual router_if)::set(null,"*","vif1",in1);
                uvm_config_db #(virtual router_if)::set(null,"*","vif2",in2);

                 //run_test("base_test");
                run_test();
        end


endmodule
