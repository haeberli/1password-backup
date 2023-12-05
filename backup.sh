#!/bin/bash

check () {
  unset EMAIL
  unset SECRETKEY
  unset PASSWORD

  chmod 700 $1
  . "$1"

  if [ -z "$EMAIL" ]; then
    echo "EMAIL not specified in $1" 
    return
  fi

  if [ -z "$SECRETKEY" ]; then
    echo "SECRETKEY not specified in $1"
    return
  fi

  if [ -z "$PASSWORD" ]; then
    echo "PASSWORD not specified in $1"
    return
  fi

  echo "Check $EMAIL started"

  eval $(echo $PASSWORD | op account add --address my.1password.com --email $EMAIL --secret-key $SECRETKEY --signin)
  
  local ids=$(op item list --format=json | jq -r ".[].id")

  local count=0
  local written=0

  for id in $ids
  do
    local item="$(op item get $id --format=json | jq .)"
    ((count++))

    local title=$(echo $item| jq -r ".title" | sed -e "s/[\\/:\*\?\"<>\|\x01-\x1F\x7F]/_/g")
    local vault=$(echo $item| jq -r ".vault.name" | sed -e "s/[\\/:\*\?\"<>\|\x01-\x1F\x7F]/_/g")

    if [ -z "$title" ]; then
      echo "Get returned no title for $id"
      continue
    fi

    local dir="./vaults/$EMAIL/$vault"
    local file="$dir/$title $id.json"

    local itemcmp=$(echo "$item" | sed -e 's/"totp":[ ]*"[^"]*"/TOTP/g')

    local exist=""
    if [ -f "$file" ]; then
      exist=$(cat "$file" | sed -e 's/"totp":[ ]*"[^"]*"/TOTP/g')
    fi

    if [[ "$itemcmp" == "$exist" ]]; then
      continue
    fi

    echo "Write $vault/$title"
    mkdir -p "$dir"
    echo "$item" > "$file"

    ((written++))
  done

  op signout

  op account forget my
  
  echo "Check $EMAIL finished: $count items, $written written"
}

while true; do
  for account in vaults/*.conf; do
    check $account
  done

  echo "Sleep 1 hour"
  sleep 3600
done
