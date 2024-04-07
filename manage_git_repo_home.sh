#!/bin/bash

script_dir_path=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
home_path=~
# home_path=~/test

if [ "${1}" == "delete" ]; then
    delete_mode=true
else
    delete_mode=false
fi
# echo ${delete_mode}

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

function _maintain_path() {
    path_is_optional=${1}
    if [[ ${path_is_optional} != true && ${path_is_optional} != false ]]; then
        # echo "${path_is_optional}"
        path_is_optional=true
    fi
    for target in "${@:2}"; do
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
            if [[ -e "${home_target}" && -e "${script_target}" && ! -L "${home_target}" ]]; then
                # \cp -r "${script_target}" "${home_target}"
                # \rm -rf "${home_target}"
                if [ ${path_is_optional} == true ]; then
                    echo "Want to delete: ${home_target}"
                else
                    if [ ${delete_mode} == true ]; then
                        \rm -rf "${home_target}"
                        echo "Deleted: ${home_target}"
                    else
                        echo "Would have deleted: ${home_target}"
                    fi
                fi
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

function maintain_path_optional() {
    _maintain_path false $@
}

function maintain_path() {
    _maintain_path true $@
}

cd "${script_dir_path}" # We do this to allow for shell globbing the paths

maintain_path .bashrc

maintain_path .icons

maintain_path .local/{bin/*,etc}
maintain_path .local/share/{bash-completion,color-schemes,konsole,plasma*}
maintain_path .local/share/nvim
maintain_path .local/share/fonts/*.ttf

maintain_path .config/{font*,htop,kdedefaults,mpv,pipewire,wireplumber,xsettingsd}
maintain_path .config/{breezerc,kdeglobals,kglobalshortcutsrc,khotkeysrc,konsolerc,kscreenlockerrc,kwinrulesrc,kwinrc,touchpad*}

maintain_path .fonts/*/*.{ttf,ttc}

maintain_path .kde/share/config/breezerc
maintain_path .kde/share/apps/color-schemes

maintain_path .irssi

maintain_path .proxychains

maintain_path .tmux.conf

maintain_path .scite
maintain_path .SciTEUser.properties

maintain_path .config/mise
maintain_path .config/nvim
maintain_path .config/alacritty
maintain_path .quiltrc-dpkg
maintain_path .tool-versions
maintain_path .config/MangoHud
maintain_path .config/gamemode.ini
maintain_path .config/OpenRGB
maintain_path .local/share/cura

maintain_path tmux_start_up_scripts
maintain_path .ansible
maintain_path Pictures/*
maintain_path .face{,.icon}
maintain_path *.sh
maintain_path .Xresources
maintain_path .inputrc

maintain_path_optional .ssh
maintain_path_optional .tmux
maintain_path_optional .config/gtk-*/*
maintain_path_optional .config/plasma-org.kde.plasma.desktop-appletsrc # This is somewhat optional as it is for widgets on plasma



# ls -alh "${home_path}"
# echo "${!permissions_paths_visited[*]}"
echo 'Done!'

