#!/bin/bash

echo "1Password Backup"

echo "- sign in"
eval $(echo $PASSWORD | op account add --address my.1password.com --email $EMAIL --secret-key $SECRETKEY --signin)
echo ". done"

echo "- list items"
items=$(op item list --format=json | jq -r ".[].id")
echo ". done"

i=1
for item in $items
do
  echo "- get $i: $item" 
  get=$(op item get $item --format=json)
  echo ". done"

  title=$(echo $get | jq -r ".title")
  vault=$(echo $get | jq -r ".vault.name")
  content="$(echo $get | jq ".")"

  echo "  Title: $title"
  echo "  Vault: $vault"

  mkdir -p "$vault"
  echo "$content" > "$vault/$title-$item.json"

  ((i++))
done

echo "- sign out"
op signout
echo ". done"
