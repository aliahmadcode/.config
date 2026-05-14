#!/usr/bin/env bash

conn=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)

if [ -z "$conn" ]; then
  echo '{"text":"󰤭  Disconnected"}'
else
  echo "{\"text\":\"󰤨  $conn\"}"
fi
