# TODO: echo ENV to config file
FROM debian:buster
RUN apt-get -y update && \
        apt-get -y install gcc libevent-dev cmake git wget libjson-c-dev
COPY . .
RUN mkdir build && cd build && \
        cmake .. && \
        make && mv xkcp* /usr/bin/
RUN echo '\
{\
        "localinterface": "ens3",\n\
        "localport": 1984,\n\
        "remoteaddr": "127.0.0.1",\n\
        "remoteport": 8388,\n\
        "key": "password",\n\
        "crypt": "aes",\n\
        "mode": "fast",\n\
        "mtu": 1350,\n\
        "sndwnd": 1024,\n\
        "rcvwnd": 1024,\n\
        "datashard": 10,\n\
        "parityshard": 3,\n\
        "dscp": 0,\n\
        "nocomp": true,\n\
        "acknodelay": false,\n\
        "nodelay": 0,\n\
        "interval": 20,\n\
        "resend": 2,\n\
        "nc": 1,\n\
        "sockbuf": 4194304,\n\
        "keepalive": 10\n\
}\n' > /etc/xkcptun.json
CMD xkcp_server -c /etc/xkcptun.json -f
