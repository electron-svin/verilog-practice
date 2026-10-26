class driver;
    virtual fifo_if vif;
    event drv_done;
    mailbox drv_mbx;

    task run();
        $display("T=%0t [Driver] starting ...", $time);
        @ (posedge vif.clk);

        forever begin
            fifo_item item;

            $display ("T=%0t [Driver] waiting for item ...", $time);
            drv_mbx.get(item);
            item.print("Driver");
            vif.push <= item.push;
            vif.data_in <= item.data_in;
            vif.pop <= item.pop;
            @(posedge vif.clk);
            ->drv_done;
        end
    endtask
endclass 