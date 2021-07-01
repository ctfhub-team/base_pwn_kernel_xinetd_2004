#!/bin/bash
if [[ -f /flag.sh ]]; then
	source /flag.sh
fi

if [[ -f /home/ctf/boot.sh ]]; then
	echo "Check Boot Script Exist"
	chmod +x /home/ctf/boot.sh
fi

if [ -z $TCPDUMP_ENABLE ]; then
    echo "Set TCPDUMP_ENABLE to enable packet capture."
else
	TCPDUMP_DIR=/var/lib/tcpdump
	if [ -z $TCPDUMP_ROTATE_SEC ]; then
		TCPDUMP_ROTATE_SEC=600
	fi
	TCPDUMP_FILENAME="capture-%F-%H-%M-%S.pcap"
	mkdir -p $TCPDUMP_DIR
	echo "TCPDUMP: capture port: 10000, rotate interval: ${TCPDUMP_ROTATE_SEC}s, capture filename: capture-\$time.pcap"
	exec /usr/sbin/tcpdump -i eth0 port 10000 -U -w $TCPDUMP_DIR/$TCPDUMP_FILENAME -G $TCPDUMP_ROTATE_SEC &
fi

export FLAG=not_flag
FLAG=not_flag

echo "Start Run xinetd"
service xinetd start
echo "Xinetd Running..."

tail -F /var/log/xinetd.log

#CMD exec sh -c "echo $FLAG > /home/ctf/flag; /etc/init.d/xinetd start; exec sleep infinity;"