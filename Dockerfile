FROM ubuntu:20.04

LABEL Organization="CTFHUB" Author="CTFHub <services@ctfhub.com>"

COPY _files /tmp

# change source
RUN cp /tmp/sources.list /etc/apt/sources.list &&\
    apt update

# setting timezone
RUN echo "" | apt install -y tzdata &&\
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    dpkg-reconfigure -f noninteractive tzdata

# install & configuration qemu xinetd
RUN apt install -y qemu-system-x86 xinetd tcpdump &&\
    mkdir -p /etc/xinetd.d &&\
    mv /tmp/xinetd.conf /etc/xinetd.conf &&\
    mv /tmp/pwn.xinetd.conf /etc/xinetd.d/pwn &&\
    mv /tmp/banner_fail /etc/banner_fail &&\
    mv /tmp/flag.sh /flag.sh &&\
    mv /tmp/boot.sh /boot.sh &&\
    mv /tmp/start.sh /start.sh &&\
    chmod +x /start.sh

# add running account
RUN useradd -U -m ctf &&\
    mkdir -p /home/ctf &&\
    rm -rf /home/ctf/.bash_logout /home/ctf/.profile /home/ctf/.bashrc &&\
    chown -R root:ctf /home/ctf &&\
    chmod -R 750 /home/ctf

# Clean
RUN apt-get clean &&\
    # /var/lib/apt/lists/* 
    rm -rf /tmp/* /var/tmp/*;

WORKDIR /home/ctf
VOLUME /var/lib/tcpdump
EXPOSE 10000
CMD ["/start.sh"]

#CMD exec sh -c "echo $FLAG > /home/ctf/flag; /etc/init.d/xinetd start; exec sleep infinity;"


