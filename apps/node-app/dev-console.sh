#!/bin/sh

tmux new-session -d "bash"
tmux rename-pane 
tmux split-window -h "cd api && npm run start:dev"
tmux split-window -h "cd api && npm run test:watch"
tmux select-pane -L
tmux select-pane -L
tmux -2 attach-session -d
