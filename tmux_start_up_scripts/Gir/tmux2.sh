#!/bin/bash
USER_HOME="/home/redm/Dropbox/VPS/tmux_start_up_scripts/Gir/"
IRSSI_MULTI="irssi_multi.sh"



chmod -R 770 $USER_HOME
tmux -L pot new-session -d ${USER_HOME}${IRSSI_MULTI}' ZNCesper'
tmux -L pot new-window ${USER_HOME}${IRSSI_MULTI}' ZNCfreenode'
tmux -L pot new-window ${USER_HOME}${IRSSI_MULTI}' ZNCrizon'
tmux -L pot new-window ${USER_HOME}${IRSSI_MULTI}' ZNCsnoo'
tmux -u -f /home/redm/Dropbox/.tmux.conf -L pot attach
