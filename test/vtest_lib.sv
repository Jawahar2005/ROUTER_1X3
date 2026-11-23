class base_test extends uvm_test;

        `uvm_component_utils(base_test)


         router_tb envh;
         env_config m_tb_cfg;

         router_wr_agent_config m_wr_cfg;
         router_rd_agent_config m_rd_cfg[];

         int has_ragent = 1;
         int has_wagent = 1;

        extern function new(string name = "base_test" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

        function base_test::new(string name = "base_test" , uvm_component parent);
                super.new(name,parent);
        endfunction

        function void base_test::build_phase(uvm_phase phase);
                m_tb_cfg = env_config::type_id::create("m_tb_cfg");
                if(has_wagent)begin
                m_wr_cfg= router_wr_agent_config :: type_id :: create("m_wr_cfg",this);
                m_wr_cfg.is_active= UVM_ACTIVE;

                if(!uvm_config_db #(virtual router_if) :: get(this, "","vif",m_wr_cfg.vif))
                `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")

                m_tb_cfg.m_wr_agent_cfg=  m_wr_cfg;


               end
                if(has_ragent) begin
                m_tb_cfg.m_rd_agent_cfg = new[m_tb_cfg.no_of_read_agents];
                m_rd_cfg=new[m_tb_cfg.no_of_read_agents];
                foreach(m_rd_cfg[i]) begin

                m_rd_cfg[i]= router_rd_agent_config :: type_id :: create($sformatf("m_rd_cfg[%0d]",i));

                m_rd_cfg[i].is_active= UVM_ACTIVE;

                if(!uvm_config_db #(virtual router_if) :: get(this,"",$sformatf("vif%0d",i), m_rd_cfg[i].vif))
                `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
                m_tb_cfg.m_rd_agent_cfg[i]= m_rd_cfg[i];
                    end
                end
        m_tb_cfg.has_wagent= has_wagent;
                m_tb_cfg.has_ragent= has_ragent;

                uvm_config_db #(env_config)::set(this,"*","env_config",m_tb_cfg);

                super.build_phase(phase);

                envh=router_tb::type_id::create("envh", this);

        endfunction

        function void base_test::end_of_elaboration_phase(uvm_phase phase);
                super.end_of_elaboration_phase(phase);
                uvm_top.print_topology();
        endfunction

class test1 extends base_test;
        `uvm_component_utils (test1)

        small_pkt_vseq seqh;

        bit [1:0] addr;

        extern function new(string name = "test1", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test1::new(string name = "test1", uvm_component parent);
        super.new(name, parent);
endfunction

function void test1::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task test1::run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
    repeat(50)begin
                addr = {$random}%3;
                uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
                seqh = small_pkt_vseq::type_id::create("seqh");
                seqh.start(envh.v_sequencer);
  end
                phase.drop_objection(this);
endtask

class test2 extends base_test;
        `uvm_component_utils (test2)

        medium_pkt_vseq seq2h;

        bit [1:0] addr;

        extern function new(string name = "test2", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test2::new(string name = "test2", uvm_component parent);
        super.new(name, parent);
endfunction

function void test2::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task test2::run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
       repeat(50)begin
                addr = {$random}%3;
                uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
                seq2h = medium_pkt_vseq::type_id::create("seq2h");
                seq2h.start(envh.v_sequencer);
    end
        phase.drop_objection(this);
endtask


class test3 extends base_test;
        `uvm_component_utils (test3)

        bit [1:0] addr;

        large_pkt_vseq seq3h;

        extern function new(string name = "test3", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test3::new(string name = "test3", uvm_component parent);
        super.new(name, parent);
endfunction

function void test3::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task test3::run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        repeat(50) begin
                addr = {$random}%3;
                uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
                seq3h = large_pkt_vseq::type_id::create("seq3h");
                seq3h.start(envh.v_sequencer);
        end
        phase.drop_objection(this);
endtask

class test4 extends base_test;
        `uvm_component_utils (test4)

        bit[1:0] addr;
        error_pkt_vseq seq4h;

        extern function new(string name= "test4", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test4::new(string name ="test4",uvm_component parent);
        super.new(name, parent);
endfunction

function void test4::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task test4::run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this);
        repeat(50) begin
                addr = {$random}%3;
                uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
                seq4h = error_pkt_vseq::type_id::create("seq4h");
                seq4h.start(envh.v_sequencer);
        end
        phase.drop_objection(this);
endtask
