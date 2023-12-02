#!/bin/bash

echo "1Password Backup"

eval $((echo $PASSWORD echo -e "\n") | op signin my.1password.com $EMAIL $SECRETKEY)

items = $(op item list)

for item in $items
    content = $(op get item ${item})
    echo $content
done

op signout
