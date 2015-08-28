FROM alpine:3.2

RUN sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf

# Networking is setup by Docker
RUN echo 'rc_provide="loopback net"' >> /etc/rc.conf

# Log boot process to /var/log/rc.log
RUN sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf

ADD my_init /sbin/

RUN  mkdir /etc/container_environment \
        && chmod a+x /sbin/my_init && mkdir /etc/service && mkdir /etc/my_init.d && \
        echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
        echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
        apk --update upgrade && apk add runit python3 && rm -rf /var/cache/apk/*

CMD ["/sbin/my_init"]
