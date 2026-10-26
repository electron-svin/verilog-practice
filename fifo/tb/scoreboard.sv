class scoreboard;
    mailbox scr_mbx;
    logic [DATA_WIDTH - 1:0] fifo_queue_out;
    logic [DATA_WIDTH - 1:0] fifo_queue [$];

    task run();
        forever begin
            fifo_item item;
            scr_mbx.get(item);

            case ({item.pop, item.push})
                2'b00:
                    begin

                    end
                2'b01:
                    begin
                        if (fifo_queue.size() == FIFO_DEPTH) begin
                            if (item.full === 1'b1) begin
                                $display ("T=%0t [Scoreboard] PASS! Full flag is raised, fifo_full=0x%0d exp_fifo_full=0x%0d",
                    												$time, item.full, 1'b1);
                            end else begin
                                $error("T=%0t [Scoreboard] FAIL! Full flag isn't raised, fifo_full=0x%0d exp_fifo_full=0x%0d",
                    											$time, item.full, 1'b1);
                            end

                        end else begin
                            fifo_queue.push_back(item.data_in);
                        end
                    end
                2'b10:
                    begin
                        if (fifo_queue.size() == 0) begin
                            if (item.empty === 1'b1) begin
                                $display ("T=%0t [Scoreboard] PASS! Empty flag is raised, fifo_empty=0x%0d exp_fifo_empty=0x%0d",
                    												$time, item.full, 1'b1);
                            end else begin
                                $error ("T=%0t [Scoreboard] FAIL! Empty flag isn't raised, fifo_empty=0x%0d exp_fifo_empty=0x%0d",
                    												$time, item.full, 1'b1);
                            end
                        end else begin
                        fifo_queue_out = fifo_queue.pop_front();
                            if (fifo_queue_out === item.data_out) begin
                                $display ("T=%0t [Scoreboard] PASS! FIFO data out correct, fifo_data_out=0x%0h exp_fifo_data_out=0x%0h",
                    												$time, item.data_out, fifo_queue_out);
                            end else begin
                                $error ("T=%0t [Scoreboard] FAIL! FIFO data out incorrect, fifo_data_out=0x%0h exp_fifo_data_out=0x%0h",
                    												$time, item.data_out, fifo_queue_out);
                            end
                        end
                    end
                2'b11:
                    begin
                        if (fifo_queue.size() == 0) begin
                            if (item.data_in === item.data_out) begin
                                $display ("T=%0t [Scoreboard] PASS! Transparent when empty, data_in=0x%0d data_out=0x%0d",
                    												$time, item.data_in, item.data_out);
                            end else begin
                                $error("T=%0t [Scoreboard] ERROR! Not transparent when empty, data_in=0x%0d data_out=0x%0d",
                    												$time, item.data_in, item.data_out);
                            end 
                    
                            if (item.empty === 1'b1) begin
                                $display ("T=%0t [Scoreboard] PASS! Empty flag is raised, fifo_empty=0x%0d exp_fifo_empt=0x%0d",
                    			$time, item.empty, 1'b1);
                            end else begin
                                $error ("T=%0t [Scoreboard] FAIL! Empty flag isn't raise, fifo_empty=0x%0d exp_fifo_empty=0x%0d",
                    			$time, item.empty, 1'b1);
                            end
                        end else begin
                            fifo_queue_out = fifo_queue.pop_front(); 
                            if (fifo_queue_out === item.data_out) begin
                                $display ("T=%0t [Scoreboard] PASS! FIFO data out correct, fifo_data_out=0x%0h exp_fifo_data_out=0x%0h",
                    												$time, item.data_out, fifo_queue_out);
                            end else begin
                                $error ("T=%0t [Scoreboard] FAIL! FIFO data out incorrect, fifo_data_out=0x%0h exp_fifo_data_out=0x%0h",
                    												$time, item.data_out, fifo_queue_out);
                            end

                            if (fifo_queue.size() == FIFO_DEPTH) begin
                                if (item.full === 1'b1) begin
                                $display ("T=%0t [Scoreboard] PASS! Full flag is raised, fifo_full=0x%0d exp_fifo_full=0x%0d",
                    												$time, item.full, 1'b1);
                                end else begin
                                $error("T=%0t [Scoreboard] FAIL! Full flag isn't raised, fifo_full=0x%0d exp_fifo_full=0x%0d",
                    											$time, item.full, 1'b1);
                                end
                            end

                            fifo_queue.push_back(item.data_in);
                        end
                    end
            endcase 

        end 

    endtask




endclass