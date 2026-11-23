class router_scoreboard extends uvm_scoreboard;

        `uvm_component_utils(router_scoreboard)

        uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh[];
        uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh;

        write_xtn wr_data;
        read_xtn rd_data;

        read_xtn read_cov_data;
        write_xtn write_cov_data;

        env_config e_cfg;

        int data_verified_count;

        extern function new(string name,uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern function void check_data(read_xtn rd);
        extern function void report_phase(uvm_phase phase);

        covergroup router_fcov1;
                option.per_instance=1;
                CHANNEL :coverpoint write_cov_data.header [1:0]{
                                                         bins low ={2'b00};
                                                         bins mid1={2'b01};
                                                        bins mid2={2'b10};
                }
                PAYLOAD_SIZE :coverpoint write_cov_data.header[7:2] {
                                                            bins small_packet ={[1:15]};
                                                            bins medium_packet ={[16:30]};
                                                            bins large_packet = {[31:63]};

                }

                BAD_PKT :coverpoint write_cov_data.error{bins bad_pkt ={1};}

                CHANNEL_X_PAYLOAD_SIZE : cross CHANNEL,PAYLOAD_SIZE;

                CHANNEL_X_PAYLOAD_SIZE_X_BAD_PKT:cross CHANNEL,PAYLOAD_SIZE,BAD_PKT;

        endgroup

        covergroup router_fcov2;
                option.per_instance=1;
                CHANNEL :coverpoint read_cov_data.header [1:0]{
                                                         bins low ={2'b00};
                                                         bins mid1={2'b01};
                                                         bins mid2={2'b10};
                }
                PAYLOAD_SIZE :coverpoint read_cov_data.header[7:2] {
                                                            bins small_packet ={[1:15]};
                                                            bins medium_packet ={[16:30]};
                                                            bins large_packet = {[31:63]};

                }
                CHANNEL_X_PAYLOAD_SIZE:cross CHANNEL,PAYLOAD_SIZE;

        endgroup

endclass

function void router_scoreboard::build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
        `uvm_fatal("EN_CFG","no update")
        fifo_wrh=new("fifo_wrh",this);
        fifo_rdh=new[e_cfg.no_of_read_agents];
        foreach(fifo_rdh[i])
        fifo_rdh[i]=new($sformatf("fifo_rdh[%0d]",i),this);
endfunction

function router_scoreboard::new(string name,uvm_component parent);
        super.new(name,parent);
        router_fcov1=new();
        router_fcov2=new();
endfunction

task router_scoreboard::run_phase(uvm_phase phase);
        fork
                forever begin
                        fifo_wrh.get(wr_data);
                        `uvm_info("WRITE SB","write data",UVM_LOW)
                        wr_data.print;
                        write_cov_data=wr_data;
                        router_fcov1.sample();
                end

                forever begin
                        fork
                                begin
                                        fifo_rdh[0].get(rd_data);
                                        `uvm_info("READ_SB[0]","read data",UVM_LOW)
                                        rd_data.print;
                                        check_data(rd_data);
                                        read_cov_data=rd_data;
                                        router_fcov2.sample();
                                end

                                begin
                                        fifo_rdh[1].get(rd_data);
                                        `uvm_info("READ_SB[1]","read data",UVM_LOW)
                                        rd_data.print;
                                        check_data(rd_data);
                                        read_cov_data=rd_data;
                                        router_fcov2.sample();
                                end

                                begin
                                        fifo_rdh[2].get(rd_data);
                                        `uvm_info("READ_SB[2]","read data ",UVM_LOW)
                                        rd_data.print;
                                        check_data(rd_data);
                                        read_cov_data=rd_data;
                                        router_fcov2.sample();
                                end
                        join_any
                        disable fork;
                end
        join
endtask

function void router_scoreboard::check_data(read_xtn rd);
        if(wr_data.header ==rd.header)
                `uvm_info("SB","HEADER MATCHED SUCESSFULLY ",UVM_MEDIUM)
        else
                `uvm_info("SB","","header COMPARISM FAILED")

        if(wr_data.payload ==rd.payload)
                `uvm_info("SB","PAYLOAD MATCHED SUCESSFULLY",UVM_MEDIUM)
        else
                `uvm_info("SB","","PAYLOAD COMPARISM FAILED")

        if(wr_data.parity ==rd.parity)
                `uvm_info("SB","PARITY MATCHED SUCESSFULLY",UVM_MEDIUM)
        else
                `uvm_info("SB","","PARITY COMPARISOM FAILED")

        data_verified_count++;

endfunction

function void router_scoreboard::report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("Report: %0d transactions verified in SB",data_verified_count),UVM_LOW)
endfunction
