class fifo_item;
    rand bit                    push;
    rand bit [DATA_WIDTH - 1:0] data_in;
    rand bit                    pop;
         bit [DATA_WIDTH - 1:0] data_out;
         bit                    full;
         bit                    empty;

    function void print(string tag="");
        $display ("T=%0t [%s] push=0x%0d data_in=%0d pop=0x%0d data_out=0x%0h full=%0d  empty=%0d", 
              			$time, tag, push, data_in, pop, data_out, full, empty);
    endfunction
endclass