class router_rd_seq extends uvm_sequence #(read_xtn);
        `uvm_object_utils (router_rd_seq)

        extern function new(string name = "router_rd_seq");
endclass

function router_rd_seq::new(string name = "router_rd_seq");
        super.new(name);
endfunction

class router_rd_xtns1 extends router_rd_seq;
        `uvm_object_utils (router_rd_xtns1)

        extern function new(string name = "router_rd_xtns1");
        extern task body();
endclass

function router_rd_xtns1::new(string name = "router_rd_xtns1");
        super.new(name);
endfunction

task router_rd_xtns1::body();
                req = read_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {no_of_cycles inside {[1:28]};})
                finish_item(req);
endtask


class router_rd_xtns2 extends router_rd_seq;
        `uvm_object_utils (router_rd_xtns2)

        extern function new(string name = "router_rd_xtns2");
        extern task body();
endclass

function router_rd_xtns2::new(string name = "router_rd_xtns2");
        super.new(name);
endfunction

task router_rd_xtns2::body();
                req = read_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {no_of_cycles inside {[30:40]};})
                finish_item(req);
endtask
