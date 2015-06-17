#!/bin/ash

# This script set SSID and Passwort from a particular Wifi interface
# with is defined for costumer user.
# created by Rene Galow, rensky at gmx.de
set -x
HOSTNAME=$1
KEY1=$2
KEY2=$3
IPADDR=$4
PASSWORD=$5
UCIPASSWORD=$(uci get bebox.UserConfig.password)

if [ x$HOSTNAME = x ]; then
    echo "USAGE: $0 HOSTNAME KEY1 KEY2 IP-ADDRESS PASSWORD"
    exit 1
fi

if [ x$KEY1 = x ]; then
    echo "USAGE: $0 HOSTNAME KEY1 KEY2 IP-ADDRESS PASSWORD"
    exit 1
fi

if [ x$KEY2 = x ]; then
    echo "USAGE: $0 HOSTNAME KEY1 KEY2 IP-ADDRESS PASSWORD"
    exit 1
fi

if [ x$IPADDR = x ]; then
    echo "USAGE: $0 HOSTNAME KEY1 KEY2 IP-ADDRESS PASSWORD"
    exit 1
fi

if [ x$PASSWORD = x ]; then
    echo "USAGE: $0 HOSTNAME KEY1 KEY2 IP-ADDRESS PASSWORD"
    exit 1
fi

if [ "$PASSWORD" != "$UCIPASSWORD" ]; then
    echo "Passwort ist falsch."
    exit 1
fi

MD5=$(echo "${HOSTNAME}${KEY1}${IPADDR}" | md5sum)
set $MD5
MD5=$1

if [ "$MD5" != "$KEY2" ] ;then
  echo "Kombination aus Hostname, Key1, Key2 und IP-Adresse stimmt nicht."
  exit 1
fi

/root/uci_start.sh

/etc/init.d/fastd disable

echo "root" > /etc/crontabs/cron.update
echo "* * * * * /usr/sbin/check.sh" > /etc/crontabs/root
echo "* * * * * sleep 30 ; /usr/sbin/check.sh" >> /etc/crontabs/root

uci set system.@system[0].hostname=$HOSTNAME
uci set network.fastd_wan.ipaddr=$IPADDR
uci set fastd.bebox.secret=$KEY1

uci commit

fastd_reboot.sh &


