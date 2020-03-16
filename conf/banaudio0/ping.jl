using ZMQ, DataStructures, Statistics, Printf

master_port = 5040
master_addr = "audiopi"
master_url = "tcp://[$(master_addr)]:$(master_port)"
@info("Connecting to $(master_url)...")

const prev_t_masters = Queue{Float64}()
function do_loop(s, sleep_amnt = .5)
    enqueue!(prev_t_masters, time()-2*sleep_amnt)
    enqueue!(prev_t_masters, time()-1*sleep_amnt)
    t_master = time()
    avg_rt = 0
    avg_abs_err = 0
    while true
        t_rt = @elapsed begin
            send(s, "")
            t_master = recv(s, Float64)
        end

        # Attempt to estimate t_master:
        ptm = collect(prev_t_masters)
        t_master_hat = ptm[end] + mean(diff(ptm .- avg_rt/2)) - avg_rt/2
        
        # Track average RTT
        avg_rt = 0.95 * avg_rt + 0.05 * t_rt

        # Track our average t_master error
        avg_abs_err = 0.95 * avg_abs_err + 0.05 * abs(t_master - t_master_hat)

        println(@sprintf("RTT: %.1fms, avg err: %.1fms, err: %.2fms", avg_rt*1000, avg_abs_err*1000, (t_master - t_master_hat)*1000))
        enqueue!(prev_t_masters, t_master)
        if length(prev_t_masters) >= 10
            dequeue!(prev_t_masters)
        end
        sleep(sleep_amnt)
    end
end


ctx = Context()
ctx.ipv6 = true
s = Socket(ctx, REQ)
connect(s, master_url)
do_loop(s)
