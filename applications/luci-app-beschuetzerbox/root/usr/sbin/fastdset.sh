#!/bin/ash

# This script set SSID and Passwort from a particular Wifi interface
# with is defined for costumer user.
# created by Ren.. Galow, rensky at gmx.de
set -x
FASTD=$1
KEY2=$2
IPADDR=$3
PASSWORD=$4
UCIPASSWORD=$(uci get bebox.UserConfig.password)

if [ x$FASTD = x ]; then
    echo "USAGE: $0 FASTDKEY KEY2 IP-ADDRESS PASSWORD"
    exit 1
fi

if [ x$KEY2 = x ]; then
    echo "USAGE: $0 FASTDKEY KEY2 IP-ADDRESS PASSWORD"
    exit 1
fi

if [ "$PASSWORD" != "$UCIPASSWORD" ]; then
    echo "Passwort ist falsch."
    exit 1
fi

MD5=$(echo "${FASTD}${IPADDR}" | md5sum)
set $MD5
MD5=$1

if [ "$MD5" != "$KEY2" ] ;then
  echo "Kombination aus Fastd Key, Key2 und IP-Addresse stimmen nicht."
  exit 1
fi

uci set network.fastd_wan.ipaddr=$IPADDR
uci set fastd.bebox.secret=$FASTD
uci commit network



