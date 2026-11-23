
class router_tb extends uvm_env;

        `uvm_component_utils (router_tb)

        router_wr_agt_top wagt_top;
        router_rd_agt_top ragt_top;

        router_virtual_sequencer v_sequencer;
        router_scoreboard sb;

        env_config m_cfg;

        extern function new(string name = "router_tb",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern function void connect_phase (uvm_phase phase);
endclass

function router_tb::new(string name = "router_tb", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_tb::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
                `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")

                if(m_cfg.has_wagent) begin
                        wagt_top = router_wr_agt_top::type_id::create("wagt_top",this);
                end

                if(m_cfg.has_ragent) begin
                        ragt_top = router_rd_agt_top::type_id::create("ragt_top",this);
                end

                if(m_cfg.has_virtual_sequencer)
                        v_sequencer = router_virtual_sequencer::type_id::create("v_sequencer",this);

                if(m_cfg.has_scoreboard)
                        sb = router_scoreboard::type_id::create("sb",this);
endfunction

function void router_tb::connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(m_cfg.has_virtual_sequencer) begin
                if(m_cfg.has_wagent)
                        v_sequencer.wr_seqrh = wagt_top.agnth.m_sequencer;
                if(m_cfg.has_ragent) begin

                for(int i=0;i<m_cfg.no_of_read_agents;i++)
                        v_sequencer.rd_seqrh[i] = ragt_top.agnth[i].m_sequencer;
                end
        end

        if(m_cfg.has_scoreboard) begin
                wagt_top.agnth.monh.monitor_port.connect(sb.fifo_wrh.analysis_export);
                foreach(ragt_top.agnth[i])
                        ragt_top.agnth[i].monh.monitor_port.connect(sb.fifo_rdh[i].analysis_export);
        end
endfunction
