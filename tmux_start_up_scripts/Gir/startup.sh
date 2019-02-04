#!/bin/bash
USER_HOME="/home/redm/Dropbox/VPS/tmux_start_up_scripts/Gir/"
chmod -R 770 $USER_HOME
hostname gir.red-m.net
if [ ! -f /tmp/bootscript ]; then
    touch /tmp/bootscript
    tmux source-file /home/redm/Dropbox/.tmux1.conf
    tmux -L default new-session -d -s 0 -n bot '/bin/bash -i'
    tmux -L default split-window -t bot -v '/bin/bash -i -c htop;/bin/bash -i'
    tmux -L default new-window -n ops $USER_HOME'ZNC.sh'
    sleep 3
    tmux -L default split-window -t ops -h $USER_HOME'tmuxWEB.sh'
    tmux -L default split-window -t ops -v -p 66 $USER_HOME'tmuxTSs.sh'
    tmux -L default split-window -t ops -v -p 50 '/bin/bash -i'
    tmux -L default select-pane -t ops -L 
    tmux -L default split-window -t ops -v -p 66 $USER_HOME'tmuxIRC.sh'
    tmux -L default split-window -t ops -v -p 50 $USER_HOME'tmuxIRCs.sh'
    tmux -L default new-window '/bin/bash -i'
    tmux -L default new-window -n su '/bin/bash -i -c '$USER_HOME'tmux2.sh;/bin/bash -i'
    tmux -L default new-window '/bin/bash -i -c ./stpy.sh;/bin/bash -i'
    tmux -L default split-window -v -p 50 '/home/redm/Dropbox/VPS/tmuxTS.sh'
    tmux -L default new-window '/bin/bash -i -c htop;/bin/bash -i'
    tmux -L default new-window '/bin/bash -i -c /'$USER_HOME'tmuxmumble.sh;/bin/bash -i'
    tmux -L default new-window '/bin/bash -i'
fi

