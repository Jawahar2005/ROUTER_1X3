class router_virtual_seqs extends uvm_sequence #(uvm_sequence_item);

        `uvm_object_utils(router_virtual_seqs)

        router_wr_sequencer wr_seqrh;
        router_rd_sequencer rd_seqrh[];

        router_virtual_sequencer vseqrh;

        env_config m_cfg;

        extern function new(string name="router_virtual_seqs");
        extern task body();
endclass

function router_virtual_seqs::new(string name="router_virtual_seqs");
        super.new(name);
endfunction

task router_virtual_seqs::body();
        if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
                `uvm_fatal(get_type_name(), "Have you set the env_config properly.?");

        rd_seqrh = new[m_cfg.no_of_read_agents];

        if($cast(vseqrh, m_sequencer))
        begin
                wr_seqrh = vseqrh.wr_seqrh;
                foreach(rd_seqrh[i])
                        rd_seqrh[i] = vseqrh.rd_seqrh[i];
        end
endtask

class small_pkt_vseq extends router_virtual_seqs;

        `uvm_object_utils (small_pkt_vseq)
        bit [1:0] addr;
        small_pkt_seq wseq;
        router_rd_xtns1 rseq;

        extern function new(string name ="small_pkt_vseq");
        extern task body();
endclass

function small_pkt_vseq::new(string name="small_pkt_vseq");
        super.new(name);
endfunction

task small_pkt_vseq::body();
        super.body();
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal (get_type_name(), "Have you set the bit[1:0] addr properly")

        if(m_cfg.has_wagent)
                wseq = small_pkt_seq::type_id::create("wseq");

        if(m_cfg.has_ragent)
                rseq = router_rd_xtns1::type_id::create("rseq");

        fork
                begin
                        wseq.start(wr_seqrh);
                end
                begin
                        if(addr == 2'b00)
                                rseq.start(rd_seqrh[0]);
                        if(addr == 2'b01)
                                rseq.start(rd_seqrh[1]);
                        if(addr == 2'b10)
                                rseq.start(rd_seqrh[2]);
                end
        join
endtask

class medium_pkt_vseq extends router_virtual_seqs;

        `uvm_object_utils (medium_pkt_vseq)
        bit [1:0] addr;
        med_pkt_seq wseq;
        router_rd_xtns1 rseq;

        extern function new(string name = "medium_pkt_vseq");
        extern task body();
endclass

function medium_pkt_vseq::new(string name = "medium_pkt_vseq");
        super.new(name);
endfunction

task medium_pkt_vseq::body();
        super.body();

        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal (get_type_name(), "Have you set the bit[1:0] addr properly")

        if(m_cfg.has_wagent)
                wseq = med_pkt_seq::type_id::create("wseq");
        if(m_cfg.has_ragent)
                rseq = router_rd_xtns1::type_id::create("rseq");

        fork
                begin
                        wseq.start(wr_seqrh);
                end
                begin
                        if(addr == 2'b00)
                                rseq.start(rd_seqrh[0]);
                        if(addr == 2'b01)
                                rseq.start(rd_seqrh[1]);
                        if(addr == 2'b10)
                                rseq.start(rd_seqrh[2]);
                end
        join
endtask

class large_pkt_vseq extends router_virtual_seqs;
        `uvm_object_utils (large_pkt_vseq)

        bit [1:0] addr;
        large_pkt_seq wseq;
        router_rd_xtns1 rseq;

        extern function new(string name ="large_pkt_vseq");
        extern task body();
endclass

function large_pkt_vseq::new(string name = "large_pkt_vseq");
        super.new(name);
endfunction

task large_pkt_vseq::body();
        super.body();

        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]", addr))
                `uvm_fatal (get_type_name(), "Have you set the bit[1:0] addr properly")

        if(m_cfg.has_wagent)
                wseq = large_pkt_seq::type_id::create("wseq");
        if(m_cfg.has_ragent)
                rseq = router_rd_xtns1::type_id::create("rseq");

        fork
                begin
                        wseq.start(wr_seqrh);
                end
                begin
                        rseq.start(rd_seqrh[addr]);
                end
        join
endtask

class error_pkt_vseq extends router_virtual_seqs;
        `uvm_object_utils (error_pkt_vseq)

        bit[1:0] addr;
        error_pkt_seq wseq;
        router_rd_xtns1 rseq;

        extern function new(string name = "error_pkt_vseq");
        extern task body();
endclass

function error_pkt_vseq::new(string name = "error_pkt_vseq");
        super.new(name);
endfunction

task error_pkt_vseq::body();
        super.body();

        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"Have you set the bit[1:0] addr properly")

        if(m_cfg.has_wagent)
                wseq = error_pkt_seq::type_id::create("wseq");
        if(m_cfg.has_ragent)
                rseq = router_rd_xtns1::type_id::create("rseq");

        fork
                begin
                        wseq.start(wr_seqrh);
                end
                begin
                        rseq.start(rd_seqrh[addr]);
                end
        join
endtask
