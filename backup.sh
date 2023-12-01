#!/bin/bash

echo "1Password Backup"
op signin 

items = $(op list items)

for item in $items
    content = $(op get item ${item})
    echo $content
done

op signout
