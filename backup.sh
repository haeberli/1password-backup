#!/bin/bash

echo "1Password Backup"

op signin --address my.1password.com --email $EMAIL --secret-key $SECRETKEY --password $PASSWORD

items = $(op list items)

for item in $items
    content = $(op get item ${item})
    echo $content
done

op signout
