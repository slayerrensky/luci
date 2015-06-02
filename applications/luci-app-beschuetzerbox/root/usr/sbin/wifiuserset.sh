#!/bin/ash

# This script set SSID and Passwort from a particular Wifi interface
# with is defined for costumer user.
# created by Ren.. Galow, rensky at gmx.de

INTERFACE=$(uci show wireless | grep setable | sed 's/.*\[\(.*\)\][^"]*$/\1/')
SSID=$1
KEY=$2
PASSWORD=$3
UCIPASSWORD=$(uci get bebox.UserConfig.password)



if [ x$SSID = x ]; then
    echo "USAGE: $0 SSID KEY PASSWORD"
    exit 1
fi

LEN=$(echo ${#SSID})
if [ $LEN -gt 32 ] ;then
  echo "Die SSID darf nicht laenger als 32 Zeichen sein."
  exit 1
fi


if [ $KEY != "null" ]; then
  if [ x$KEY = x ];  then
    echo "USAGE: $0 SSID KEY PASSWORD"
    exit 1
  fi
  KEYLENGHT=$(echo ${#KEY})
  if [ $KEYLENGHT -gt 64 ] || [ $KEYLENGHT -lt 8 ]; then
      echo "Key darf nur zwischen 8 und 64 zeichen lang sein."
      exit 1
  fi
fi


if [ "$PASSWORD" != "$UCIPASSWORD" ]; then
    echo "Passwort ist falsch."
    exit 1
fi

if [ $KEY == "null" ]; then
  uci set wireless.@wifi-iface[$INTERFACE].encryption=none
else
  uci set wireless.@wifi-iface[$INTERFACE].encryption=psk2
  uci set wireless.@wifi-iface[$INTERFACE].ssid="$SSID"
  uci set wireless.@wifi-iface[$INTERFACE].key="$KEY"
fi
uci commit wireless
wifi

