class monitor;
    virtual fifo_if vif;
    mailbox scr_mbx;

    task run();
        $display ("T=%0t [Monitor] starting ...", $time);

        forever begin
            @(posedge vif.clk);
            if (vif.push | vif.pop) begin
                fifo_item item = new;
                item.push = vif.push;
                item.data_in = vif.data_in;
                item.pop = vif.pop;
                item.data_out = vif.data_out;
                item.empty = vif.empty;
                item.full = vif.full;
                item.print("Monitor");
                scr_mbx.put(item);
            end
        end
    endtask
endclass 