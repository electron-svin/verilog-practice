class test;
    env e0;
    mailbox drv_mbx;

    function new();
        drv_mbx = new();
        e0 = new();
    endfunction

    virtual task run();
        e0.d0.drv_mbx = drv_mbx;

        fork 
            e0.run();
        join_none

        apply_stim();
    endtask

    virtual task apply_stim();
        fifo_item item;

        $display("T=%0t [Test] Starting stimulus ...", $time);

         // Full check 
        for (int i = 0; i < FIFO_DEPTH + 1; i++) begin
            item = new;
            item.randomize() with {push == 1'b1; pop == 1'b0;};
            drv_mbx.put(item);
        end

        // Random test
        for (int i = 0; i < 100; i++) begin
            item = new;
            item.randomize();
            drv_mbx.put(item);
        end

        // Full check 
        for (int i = 0; i < FIFO_DEPTH + 1; i++) begin
            item = new;
            item.randomize() with {push == 1'b1; pop == 1'b0;};
            drv_mbx.put(item);
        end

        // Random test
        for (int i = 0; i < 100; i++) begin
            item = new;
            item.randomize();
            drv_mbx.put(item);
        end

    endtask
endclass