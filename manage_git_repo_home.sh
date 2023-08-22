#!/bin/bash

script_dir_path=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
home_path=~
# home_path=~/test

if [ ! -d "${home_path}" ]; then
    mkdir -p "${home_path}"
    chmod 700 "${home_path}"
fi

declare -A permissions_paths_visited=()
export permissions_paths_visited

function maintain_permissions() {
    script_target="${1}"
    recur_target=$(readlink -m "${script_target}/.." | sed -E 's#^'"${script_dir_path}"'(\/|)##')
    while [ $(readlink -m "${script_dir_path}/${recur_target}") != "${script_dir_path}" ]; do
        source_permissions="${script_dir_path}/${recur_target}"
        target_permissions=$(readlink -m "${home_path}/${recur_target}")
        if [[ ${permissions_paths_visited[$source_permissions]} == "" ]]; then
            permissions_paths_visited[$source_permissions]="a"
            if [[ -e "${target_permissions}" && ! -L "${target_permissions}" ]]; then
                permissions_paths_visited[$source_permissions]=$(stat -L -c "%a %G %U" "${source_permissions}")
                if [[ $(stat -L -c "%a %G %U" "${target_permissions}") != ${permissions_paths_visited[$source_permissions]} ]]; then
                    chmod --reference="${source_permissions}" "${target_permissions}"
                    chown --reference="${source_permissions}" "${target_permissions}"
                    echo "Updated permissions: ${target_permissions}"
                fi
            fi
        fi
        recur_target=$(readlink -f "${source_permissions}/.." | sed -E 's#^'"${script_dir_path}"'(\/|)##')
    done
}

function maintain_path() {
    for target in $@; do
        script_target="${script_dir_path}/${target}"
        home_target="${home_path}/${target}"
        home_target_up_one=$(readlink -m "${home_target}/..")
        if [ -e "${script_target}" ]; then
            if [ "${home_target_up_one}" != "${home_path}" ]; then
                if [ ! -e "${home_target_up_one}" ]; then
                    mkdir -p "${home_target_up_one}"
                    echo "Made directory: ${home_target_up_one}"
                fi
            fi
            if [[ -e "${home_target}" && ! -L "${home_target}" ]]; then
                # \cp -r "${script_target}" "${home_target}"
                # \rm -rf "${home_target}"
                echo "Want to delete: ${home_target}"
            fi
            maintain_permissions "${script_target}"
            if [[ -L "${home_target}" && $(readlink -f -- "${home_target}") != "${script_target}" ]]; then
                \rm "${home_target}"
                echo "Updating symblink: ${home_target}"
            fi
            if [ ! -e "${home_target}" ]; then
                # \cp -r "${script_target}" "${home_target}"
                ln -s "${script_target}" "${home_target}"
                echo "Created symblink: ${target}"
            fi
        fi
    done
}

cd "${script_dir_path}" # We do this to allow for shell globbing the paths

maintain_path .bashrc
maintain_path .ssh

maintain_path .icons

maintain_path .local/{bin/*,etc}
maintain_path .local/share/{bash-completion,color-schemes,konsole,plasma*}
maintain_path .local/share/fonts/*.ttf

maintain_path .config/{font*,htop,kdedefaults,mpv,pipewire,wireplumber,xsettingsd}
maintain_path .config/gtk-*/*
maintain_path .config/{breezerc,kdeglobals,khotkeysrc,konsolerc,kscreenlockerrc,kwinrulesrc,touchpad*}

maintain_path .fonts/*/*.{ttf,ttc}

maintain_path .kde/share/config/breezerc
maintain_path .kde/share/apps/color-schemes

maintain_path .irssi

maintain_path .proxychains

maintain_path .tmux
maintain_path .tmux.conf

maintain_path .scite
maintain_path .SciTEUser.properties

maintain_path tmux_start_up_scripts
maintain_path Pictures/*
maintain_path *.sh




# ls -alh "${home_path}"
# echo "${!permissions_paths_visited[*]}"
echo 'Done!'
