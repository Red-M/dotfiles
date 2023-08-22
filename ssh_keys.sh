#!/bin/bash
export $(gnome-keyring-daemon -s)
echo $SSH_AUTH_SOCK
ssh-add /home/redm/keys/*.key
