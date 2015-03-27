#!/bin/ash

# This script set SSID and Passwort from a particular Wifi interface
# with is defined for costumer user.
# created by René Galow, rensky at gmx.de

INTERFACE=$(uci show wireless | grep setable | sed 's/.*\[\(.*\)\][^"]*$/\1/')
SSID=$1
KEY=$2
PASSWORD=$3
UCIPASSWORD=$(uci get bebox.UserConfig.password)

if [ x$SSID = x ]; then
    echo "USAGE: $0 SSID KEY PASSWORD"
    exit 1
fi

if [ x$KEY = x ]; then
    echo "USAGE: $0 SSID KEY PASSWORD"
    exit 1
fi

if [ "$PASSWORD" != "$UCIPASSWORD" ]; then
    echo "Password not match."
    exit 1
fi


KEYLENGHT=$(echo ${#KEY})
if [ $KEYLENGHT -gt 64 ] || [ $KEYLENGHT -lt 8 ]; then
    echo "Key lenght must be between 8 an 64 character."
    exit 1
fi

uci set wireless.@wifi-iface[$INTERFACE].ssid=$SSID
uci set wireless.@wifi-iface[$INTERFACE].key=$KEY
uci commit wireless
wifi

