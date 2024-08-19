#!/bin/bash

SERVICE=$(/usr/bin/which service)
SLEEP=$(/usr/bin/which sleep)
BASH=$(/usr/bin/which bash)

$SERVICE ssh start
$SLEEP 3s
$BASH /app/upload_users_to_vault.sh
$SLEEP infinity
