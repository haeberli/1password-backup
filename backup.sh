#!/bin/bash

check () {
  unset EMAIL
  unset SECRETKEY
  unset PASSWORD
  unset VAULT

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

  if [ ! -z "$VAULT" ]; then
    VAULTARG="--vault $VAULT"
  fi 
  
  echo "Check $EMAIL started"

  eval $(echo "$PASSWORD" | op account add --address my.1password.com --email $EMAIL --secret-key $SECRETKEY --signin)
  
  local ids=$(op item list --format=json $VAULTARG | jq -r ".[].id")

  local existing=$(find "./vaults/$EMAIL" -type f)

  local count=0
  local added=0
  local updated=0
  local deleted=0

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

    mkdir -p "$dir"

    existing="${existing/$file}"

    if [ -f "$file" ]; then
      local itemcmp=$(echo "$item" | sed -e 's/"totp":[ ]*"[^"]*"/TOTP/g')
      local exist=$(cat "$file" | sed -e 's/"totp":[ ]*"[^"]*"/TOTP/g')

      if [[ "$itemcmp" == "$exist" ]]; then
        continue
      fi
 
      echo "Updated $vault/$title"
      echo "$item" > "$file"
      ((updated++))
    else 
      echo "Added $vault/$title"
      echo "$item" > "$file"
      ((added++))
    fi

  done

  OLDIFS="$IFS"
  IFS="
"
  for file in $existing
  do 
    echo "Deleted $file"
    rm "$file"
    ((deleted++))
  done
  IFS=$OLDIFS

  op signout

  op account forget my
  
  echo "Check $EMAIL finished: $count items, $added added, $updated updated, $deleted deleted"
}

while true; do
  for account in vaults/*.conf; do
    check $account
  done

  echo "Sleep 1 hour"
  sleep 3600
done
