#!/bin/bash

INSTALL_PY=0

SLEEP=false

ROOTDIR=$(dirname "$0")
if [ "$ROOTDIR" = "." ]; then
    ROOTDIR=$(pwd)
fi
echo "1. ROOTDIR:$ROOTDIR"

CPUARCH=$(uname -i)

if [ "$CPUARCH" = "x86_64" ]; then
    CPUARCH=amd64
fi

VENV=$ROOTDIR/.venv
REQS=$ROOTDIR/requirements.txt

PYTHON39=$(which python3.9)
PIP3=$(which pip3)

sleeping () {
    while true; do
        echo "Sleeping... this is what this is supposed to do but this keesp the container running forever and it is doing wakeonlan's."
        sleep 999999999
    done
}

apt-get update -y && apt-get upgrade -y

export DEBIAN_FRONTEND=noninteractive

export TZ=America/Denver

apt-get install -y tzdata

if [ "$INSTALL_PY" == "1" ]; then
    if [ -z "$PYTHON39" ]; then
        echo "Python 3.9 is not installed. Installing now..."
        apt-get update -y
        apt install software-properties-common -y
        add-apt-repository ppa:deadsnakes/ppa -y
        apt-get install python3.9 -y
        PYTHON39=$(which python3.9)
    fi

    if [ -z "$PIP3" ]; then
        echo "Pip 3 is not installed. Installing now..."
        apt-get install python3-pip -y
        PIP3=$(which pip3)
    fi

    echo "python39=$PYTHON39"
    echo "PIP3=$PIP3"
fi

apt-get update -y
apt-get install net-tools -y
apt install iputils-ping -y
apt-get install nano -y

apt-get update -y

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$CPUARCH signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y

apt-get install docker-ce-cli -y

DOCKERVERS=$(docker --version)

if [ ! -z "$DOCKERVERS" ]; then
    echo "Docker is not installed. Cannot continue..."
    sleeping
fi

##########################################################################

PRODUCT=$ROOTDIR/pi-hole

if [ ! -d "$PRODUCT" ]; then
    echo "Product directory does not exist. Cannot continue..."
    sleeping
fi

MAKEVOLS=$ROOTDIR/pi-hole/create_volumes.sh

if [ ! -f "$MAKEVOLS" ]; then
    echo "MAKEVOLS ($MAKEVOLS) does not exist. Cannot continue..."
    sleeping
fi

chmod +x $MAKEVOLS

./$MAKEVOLS

docker-compose up -d

##########################################################################
echo "Done."
sleeping
