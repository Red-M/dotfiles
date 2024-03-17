```
su -l -c'apt update && apt install -y git curl build-essential devscripts debian-handbook nano htop python3-pip python3-pip-whl apt-build tar tmux scite ansible'

git clone --recurse-submodules https://github.com/Red-M/dotfiles.git ~/git/Red_M/dotfiles
~/git/Red_M/dotfiles/manage_git_repo_home.sh
```

