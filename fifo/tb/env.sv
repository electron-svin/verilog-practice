class env;
    driver d0;
    monitor m0;
    scoreboard s0;
    mailbox scr_mbx;
    virtual fifo_if vif;

    function new();
        d0 = new;
        m0 = new;
        s0 = new;
        scr_mbx = new();
    endfunction

    virtual task run();
        d0.vif = vif;
        m0.vif = vif;
        m0.scr_mbx = scr_mbx;
        s0.scr_mbx = scr_mbx;

        fork 
            d0.run();
            m0.run();
            s0.run();
        join_any
    endtask
endclass