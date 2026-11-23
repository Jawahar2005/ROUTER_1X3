class write_xtn extends uvm_sequence_item;

        `uvm_object_utils (write_xtn)

        bit reset_n;
        bit pkt_valid;
        bit error;
        bit busy;

        rand bit[7:0]header;
        rand bit[7:0]payload[];
        rand bit[7:0]parity;

        constraint a1{ header[1:0] != 2'b11; }
        constraint a2{ payload.size == header[7:2] && header[7:2]!=0; }

        extern function new(string name = "write_xtn");
        extern function void do_print(uvm_printer printer);
        extern function void post_randomize();
endclass

function write_xtn::new(string name = "write_xtn");
        super.new(name);
endfunction

function void  write_xtn::do_print (uvm_printer printer);
    super.do_print(printer);


    printer.print_field( "header", this.header, 8, UVM_DEC);
    foreach(payload[i])
    begin
    printer.print_field( $sformatf("payload[%0d]", i),this.payload[i],8, UVM_DEC);
    end

    printer.print_field( "parity",this.parity,8,UVM_DEC);

 endfunction

function void write_xtn::post_randomize();
   parity = 0 ^ header;
   foreach(payload[i])
   parity = parity ^ payload[i] ;
endfunction : post_randomize
