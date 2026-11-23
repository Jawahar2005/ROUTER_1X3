class router_wr_agt_top extends uvm_env;

        `uvm_component_utils(router_wr_agt_top)

        router_wr_agent agnth;
        env_config m_cfg;

        extern function new(string name = "router_wr_agt_top", uvm_component parent);
        extern function void build_phase(uvm_phase phase);

endclass

function router_wr_agt_top::new(string name = "router_wr_agt_top", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_wr_agt_top::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
                `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
        uvm_config_db #(router_wr_agent_config)::set(this,"*","router_wr_agent_config",m_cfg.m_wr_agent_cfg);
        agnth=router_wr_agent::type_id::create("agnth",this);

endfunction
