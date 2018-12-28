#!/bin/zsh

source ~/.zshrc

# Start the tmux server with a default session
tmux new-session -s default -n default -d

# Simple loop to keep the tmux server running
while :; do
  tmux list-windows
  sleep 300
done
