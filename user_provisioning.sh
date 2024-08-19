#!/bin/bash

GROUPADD=$(/usr/bin/which groupadd)
USERADD=$(/usr/bin/which useradd)
MKDIR=$(/usr/bin/which mkdir)
PWGEN=$(/usr/bin/which pwgen)
CHPASSWD=$(/usr/bin/which chpasswd)
CHMOD=$(/usr/bin/which chmod)
CHOWN=$(/usr/bin/which chown)
SSHKEYGEN=$(/usr/bin/which ssh-keygen)
MV=$(/usr/bin/which mv)

$GROUPADD -g 1250 admins
$GROUPADD -g 1666 devs
$GROUPADD -g 1444 supports

admins_users=("Leandro" "Enzo")
devs_users=("Juan" "Sofia" "Cristian" "Nicolas" "Sebastian")
supports_users=("Ramiro" "Camila" "Hector")

create_ssh_keys_for_user() {
  local user_name=$1
  local user_group=$2
  local ssh_key_path="/home/$1/.ssh"
  $MKDIR $ssh_key_path
  $CHMOD 700 $ssh_key_path
  $SSHKEYGEN -f "${ssh_key_path}/id_rsa" -N ""
  $MV "${ssh_key_path}/id_rsa.pub" "${ssh_key_path}/authorized_keys"
  $CHMOD 600 "${ssh_key_path}/authorized_keys"
  $CHOWN -R  "${user_name}:${user_group}" "${ssh_key_path}"
}

create_users() {
  local users_array=("${!1}")
  local group_name=$2
  for user in "${users_array[@]}"; do
    $USERADD -m -s /bin/bash -g $group_name $user
    local password=$($PWGEN -ys 12 1)
    local home_path="/home/${user}"
    echo "${user}:${password}" | $CHPASSWD
    echo "${user} ${password}" >> ${group_name}.txt
    create_ssh_keys_for_user "$user" "$group_name"
  done
}

create_users admins_users[@] "admins"
create_users devs_users[@] "devs"
create_users supports_users[@] "supports"
