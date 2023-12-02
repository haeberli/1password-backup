#!/bin/bash

echo "1Password Backup"

echo "- sign in"
eval $((echo $PASSWORD echo -e "\n") | op signin my.1password.com $EMAIL $SECRETKEY)
echo "  succeeded"

echo "- list items"
items = $(op list item)
echo "  succeeded"

for item in $items
    echo "- get item"
    content = $(op get item ${item})
    echo "  succeeded"
    
    echo $content
done

echo "- sign out"
op signout
echo "  succeeded"
