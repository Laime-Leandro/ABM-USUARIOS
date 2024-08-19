#!/bin/bash 

CURL=$(/usr/bin/which curl)
JQ=$(/usr/bin/which jq)

create_secret() {
  local secret_name=$1
  $CURL \
      --header "X-Vault-Token: dev-only-token" \
      --header "Content-Type: application/json" \
      --request POST \
      --data '{"data": {}}' \
      http://"${VAULT_IP}":8200/v1/secret/data/"${secret_name}"
}

upload_secret() {
  local user_name=$1
  local user_password=$2
  local group_name=$3
  local json=$($JQ -n --arg username "$user_name" --arg password "$user_password" '{data: {($username): $password}}')
  $CURL \
      --header "X-Vault-Token: dev-only-token" \
      --header "Content-Type: application/merge-patch+json" \
      --request PATCH \
      --data "$json"  \
      http://"${VAULT_IP}":8200/v1/secret/data/"${group_name}"
}

upload_to_vault() {
  local group_name=$1
  local file=$2

  create_secret "$group_name"
  
  while IFS=" " read -r username password; do 
    upload_secret "$username" "$password" "$group_name"
  done < "$file"
}

upload_to_vault "admins" admins.txt
upload_to_vault "devs" devs.txt
upload_to_vault "supports" supports.txt
