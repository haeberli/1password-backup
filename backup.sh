#!/bin/bash

echo "1Password Backup"

op account add --address my.1password.com --email $EMAIL --secret-key $SECRETKEY --signin 

items = $(op list items)

for item in $items
    content = $(op get item ${item})
    echo $content
done

op signout
