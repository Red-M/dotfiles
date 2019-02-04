#!/bin/bash
chmod -R 770 /home/redm/Dropbox/VPS/tmux_start_up_scripts/Gir_2/
if [ ! -f /tmp/bootscript ]; then
    touch /tmp/bootscript
    tmux source-file /home/redm/Dropbox/.tmux1.conf
    tmux -L default new-session -d -s 0 -n htop '/bin/bash -i -c htop;/bin/bash -i'
    tmux -L default new-window -n ops '/home/redm/Dropbox/VPS/tmux_start_up_scripts/Gir_2/iris.sh'
    sleep 3
    tmux -L default split-window -t ops -h '/home/redm/Dropbox/VPS/tmux_start_up_scripts/Gir_2/TSDNS.sh'
    tmux -L default split-window -t ops -v -p 50  '/home/redm/Dropbox/VPS/tmux_start_up_scripts/Gir_2/TS.sh'
    tmux -L default select-pane -t ops -L 
    tmux -L default split-window -t ops -v -p 50 '/home/redm/Dropbox/VPS/tmux_start_up_scripts/Gir_2/webserver.sh'
    tmux -L default new-window '/bin/bash -i'
fi

