#!/bin/bash

ROOTDIR=$(dirname "$0")
if [ "$ROOTDIR" = "." ]; then
    ROOTDIR=$(pwd)
fi
echo "1. ROOTDIR:$ROOTDIR"

sleeping () {
    while true; do
        echo "Sleeping..."
        sleep 9999s
    done
}

##################################################
ETC_PIHOLE_VOLNAME=etcpihole

ETC_PIHOLE_TEST=$(docker volume ls | grep $ETC_PIHOLE_VOLNAME)

if [ -z "$ETC_PIHOLE_TEST" ]; then
    docker volume create $ETC_PIHOLE_VOLNAME
fi

ETC_PIHOLE_DIR=$ROOTDIR/etc-pihole

if [ -d "$ETC_PIHOLE_DIR" ]; then
    echo "INFO: ETC_PIHOLE_DIR:$ETC_PIHOLE_DIR directory exists. Proceeding."
else
    echo "ERROR: ETC_PIHOLE_DIR:$ETC_PIHOLE_DIR directory does not exist. Cannot continue."
    sleeping
fi

ETC_PIHOLE_VOLUME_DIR=$(docker volume inspect $ETC_PIHOLE_VOLNAME | jq -r '.[0].Mountpoint')

if [ -d "$ETC_PIHOLE_VOLUME_DIR" ]; then
    echo "INFO: ETC_PIHOLE_VOLUME_DIR:$ETC_PIHOLE_VOLUME_DIR volume directory exists. Proceeding."
else
    echo "ERROR: ETC_PIHOLE_VOLUME_DIR:$ETC_PIHOLE_VOLUME_DIR volume directory does not exist. Cannot continue."
    exit
fi

#cp -R $ETC_PIHOLE_DIR/ $ETC_PIHOLE_VOLUME_DIR/

##################################################

ETC_DNSMASQD_VOLNAME=etcdnsmasqd

ETC_DNSMASQD_TEST=$(docker volume ls | grep $ETC_DNSMASQD_VOLNAME)

if [ -z "$ETC_DNSMASQD_TEST" ]; then
    docker volume create $ETC_DNSMASQD_VOLNAME
fi

ETC_DNSMASQD_DIR=$ROOTDIR/etc-dnsmasq.d

if [ -d "$ETC_DNSMASQD_DIR" ]; then
    echo "INFO: ETC_DNSMASQD_DIR:$ETC_DNSMASQD_DIR directory exists. Proceeding."
else
    echo "ERROR: ETC_DNSMASQD_DIR:$ETC_DNSMASQD_DIR directory does not exist. Cannot continue."
    sleeping
fi

ETC_DNSMASQD_VOLUME_DIR=$(docker volume inspect $ETC_DNSMASQD_VOLNAME | jq -r '.[0].Mountpoint')

if [ -d "$ETC_DNSMASQD_VOLUME_DIR" ]; then
    echo "INFO: ETC_DNSMASQD_VOLUME_DIR:$ETC_DNSMASQD_VOLUME_DIR volume directory exists. Proceeding."
else
    echo "ERROR: ETC_DNSMASQD_VOLUME_DIR:$ETC_DNSMASQD_VOLUME_DIR volume directory does not exist. Cannot continue."
    exit
fi

#cp -R $ETC_DNSMASQD_DIR/ $ETC_DNSMASQD_VOLUME_DIR/

##################################################
