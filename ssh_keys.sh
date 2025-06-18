#!/bin/bash

if [ -S "${XDG_RUNTIME_DIR}/gcr/ssh" ]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gcr/ssh"
else
  export $(gnome-keyring-daemon -s)
fi

echo $SSH_AUTH_SOCK
ssh-add /home/redm/keys/*.key

