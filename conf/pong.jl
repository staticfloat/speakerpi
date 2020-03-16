using ZMQ

@info("Listening on tcp://*:5040")

function do_loop(s)
    while true
        # Block on receiving a message; we don't care about the actual contents
        recv(s)

        # Return the current time, as quick as we can
        send(s, time())
    end
end

ctx = Context()
ctx.ipv6 = true
s = Socket(ctx, REP)
bind(s, "tcp://*:5040")
do_loop(s)
