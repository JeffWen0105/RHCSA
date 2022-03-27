#!/bin/bash

export LIBVIRT_DEFAULT_URI=qemu:///system


function log_info() {
  DATE=$(date "+%Y-%m-%d %H:%M:%S")
  echo -e "\033[32m$DATE [INFO]: $1 \033[0m"
}

function log_err() {
  DATE=$(date "+%Y-%m-%d %H:%M:%S")
  echo -e "\033[31m$DATE [ERROR]: $1 \033[0m"
}

function start(){
log_info "重置 serverc ..."
virsh destroy serverc
rm -f /var/lib/libvirt/images/serverc
qemu-img create -b /var/lib/libvirt/images/serverc_base.qcow2 -f qcow2 /var/lib/libvirt/images/serverc.qcow2 
rm -f /var/lib/libvirt/images/serverc-00?.qcow2 && \
for i in {1..2}
    do
        qemu-img create -b /var/lib/libvirt/images/serverc-00${i}_base.qcow2 -f qcow2 /var/lib/libvirt/images/serverc-00${i}.qcow2 
    done
qemu-img create -f qcow2 /var/lib/libvirt/images/serverc-003.qcow2 10G 
log_info "vdd 硬碟擴展完畢.."
virsh start serverc > /dev/null 2>&1
log_info "serverc 重新開機中... 請耐心等待"

}

function main(){
    start
}




main