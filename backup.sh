#!/bin/bash

echo "1Password Backup"

echo "- sign in"
eval $((echo $PASSWORD echo -e "\n") | op signin my.1password.com $EMAIL $SECRETKEY)
echo "  done"

echo "- list items"
items = $(op item list)
echo "  done"

for item in $items
    echo "- get item"
    content = $(op item get ${item})
    echo "  done"
    
    echo $content
done

echo "- sign out"
op signout
echo "  done"
