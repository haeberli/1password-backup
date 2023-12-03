#!/bin/bash

check () {
  unset EMAIL
  unset SECRETKEY
  unset PASSWORD

  chmod 700 $1
  . "$1"

  if [ -z "$EMAIL" ]; then
    echo "EMAIL not specified"
    return
  fi

  if [ -z "$SECRETKEY" ]; then
    echo "SECRETKEY not specified"
    return
  fi

  if [ -z "$PASSWORD" ]; then
    echo "PASSWORD not specified"
    return
  fi

  echo "Check $EMAIL"

  eval $(echo $PASSWORD | op account add --address my.1password.com --email $EMAIL --secret-key $SECRETKEY --signin)

  echo "List items"
  local ids=$(op item list --format=json | jq -r ".[].id")

  local count=0
  local written=0

  for id in $ids
  do
    echo "Get $count: $id" 
    local item="$(op item get $id --format=json | jq .)"
    ((count++))

    local title=$(echo $item| jq -r ".title" | sed -e "s/[\\/:\*\?\"<>\|\x01-\x1F\x7F]/_/g")
    local vault=$(echo $item| jq -r ".vault.name" | sed -e "s/[\\/:\*\?\"<>\|\x01-\x1F\x7F]/_/g")

    if [ -z "$title" ]; then
      echo "Empty title > skip"
      continue
    fi

    local dir="./vaults/$EMAIL/$vault"
    local file="$dir/$title $id.json"

    local exist=""
    if [ -f "$file" ]; then
      exist=$(cat "$file")
    fi

    if [[ "$item" == "$exist" ]]; then
      continue
    fi

    echo "Write $vault/$title"
    mkdir -p "$dir"
    echo "$item" > "$file"

    ((written++))
  done

  echo "Sign out"
  op signout

  echo "Check $EMAIL finished: $count items, $written written"
}

while true; do
  for account in vaults/*.conf; do
    check $account
  done

  echo "Sleep 1 hour"
  sleep 3600
done
