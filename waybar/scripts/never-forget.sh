#!/bin/bash

always="/home/ali/map/dev/reads/principles/always"
never="/home/ali/map/dev/reads/principles/never"

always_lines=$(wc -l < "$always")
never_lines=$(wc -l < "$never")

random1=$((RANDOM % always_lines + 1))
random2=$((RANDOM % never_lines + 1))

random3=$((RANDOM % 100 + 1))

if [[ "$random3" -gt 50 ]]; then
  SHOW="$(head -n "$random1" "$always" | tail -n 1)"
  echo "{\"text\": \"$SHOW (always)\"}"
else 
  SHOW="$(head -n "$random2" "$never" | tail -n 1)"
  echo "{\"text\": \"$SHOW (never)\"}"
fi
