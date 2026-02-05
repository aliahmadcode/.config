#!/bin/bash

CMD=$(tmux ls -F\#W)

PATH_FULL=$(tmux display-message -p "#{pane_current_path}")

echo "{\"text\": \"$CMD $PATH_FULL \"}"

