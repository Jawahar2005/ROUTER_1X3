class router_wr_seqs extends uvm_sequence #(write_xtn);

        `uvm_object_utils (router_wr_seqs)

        extern function new(string name = "router_wr_seqs");
endclass

function router_wr_seqs::new(string name = "router_wr_seqs");
        super.new(name);
endfunction

class small_pkt_seq extends router_wr_seqs;

        `uvm_object_utils (small_pkt_seq);
        bit [1:0] addr;
        extern function new(string name = "small_pkt_seq");
        extern task body();

endclass

function small_pkt_seq::new(string name = "small_pkt_seq");
        super.new(name);
endfunction

task small_pkt_seq::body();
        req = write_xtn::type_id::create("req");
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal (get_type_name(), "have you set the bit[1:0] addr")
        start_item(req);
        assert(req.randomize() with {header[7:2] inside {[1:15]} && addr == header[1:0];} );
        finish_item(req);
endtask

class med_pkt_seq extends router_wr_seqs;

        `uvm_object_utils (med_pkt_seq);
        bit [1:0] addr;
        extern function new(string name="med_pkt_seq");
        extern task body();
endclass

function med_pkt_seq::new(string name="med_pkt_seq");
        super.new(name);
endfunction

task med_pkt_seq::body();
        req = write_xtn::type_id::create("req");
          if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal (get_type_name(), "have you set the bit[1:0] addr")
        start_item(req);
        assert(req.randomize() with {header[7:2] inside {[16:30]}; header[1:0]==addr;});
        finish_item(req);
endtask

class large_pkt_seq extends router_wr_seqs;

        `uvm_object_utils (large_pkt_seq);
        bit [1:0] addr;
        extern function new(string name="large_pkt_seq");
        extern task body();
endclass

function large_pkt_seq::new(string name="large_pkt_seq");
        super.new(name);
endfunction

task large_pkt_seq::body();
        req = write_xtn::type_id::create("req");
         if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal (get_type_name(), "have you set the bit[1:0] addr")
        start_item(req);
        assert(req.randomize() with {header[7:2] inside {[31:63]}; header[1:0]==addr;});
        finish_item(req);
endtask

class error_pkt_seq extends router_wr_seqs;
        `uvm_object_utils (error_pkt_seq)

        bit [1:0] addr;
        extern function new(string name = "error_pkt_seq");
        extern task body();
endclass

function error_pkt_seq::new(string name = "error_pkt_seq");
        super.new(name);
endfunction

task error_pkt_seq::body();

        req = write_xtn::type_id::create("req");
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(), "bit[1:0]",addr))
                `uvm_fatal (get_type_name(), "Have you set the bit[1:0] addr");

        start_item(req);
        assert(req.randomize() with {header[7:2] inside {[0:63]}&&header[1:0] == addr;})
        req.parity ^= 1;
        finish_item(req);

endtask
~
