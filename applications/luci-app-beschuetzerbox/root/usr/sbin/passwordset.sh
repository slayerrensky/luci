#!/bin/ash

# This script set SSID and Passwort from a particular Wifi interface
# with is defined for costumer user.
# created by Ren.. Galow, rensky at gmx.de

PASSWORDNEW=$1
PASSWORD=$2
UCIPASSWORD=$(uci get bebox.UserConfig.password)

if [ $PASSWORDNEW == "" ]; then
    echo "USAGE: $0 NEW_PASSWORD PASSWORD"
    exit 1
fi

if [ "$PASSWORD" != "$UCIPASSWORD" ]; then
    echo "Password not match."
    exit 1
fi

uci set bebox.UserConfig.password=$PASSWORDNEW
uci commit bebox

