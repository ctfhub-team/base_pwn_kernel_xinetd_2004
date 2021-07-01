#!/bin/sh

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd `dirname $0`

exec timeout -s 9 300s qemu-system-x86_64  \
    -m 64M \
    -cpu kvm64,+smep,+smap \
    -kernel bzImage \
    -initrd rootfs.cpio \
    -nographic \
    -monitor none \
    -drive format=raw,snapshot=on,file=flag \
    -append "console=ttyS0 kaslr quiet panic=1"

