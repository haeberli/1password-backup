#!/bin/bash

echo "1Password Backup"

echo "- sign in"
eval $(echo $PASSWORD | op account add --address my.1password.com --email $EMAIL --secret-key $SECRET --signin)
echo ". done"

echo "- list items"
items=$(op item list --format=json | jq -r ".[].id")
echo ". done"

for item in $items
do
  echo "- get item" 
  op item get $item --format=json
  echo ". done"
done

echo "- sign out"
op signout
echo ". done"
