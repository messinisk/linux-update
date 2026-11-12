#!/usr/bin/env bash
# shellcheck disable=SC1091


info_zypper() {

    while true
    do

        show_package_menu "ZYPPER Operations"

        case "$?" in

            1) update_zypper ;;
            2) upgrade_zypper ;;
            3) autoremove_zypper ;;
            4) clean_zypper ;;
            5) break ;;

        esac

    done
}


update_zypper() {
    sudo zypper refresh
}

upgrade_zypper() {
    sudo zypper update -y
}

autoremove_zypper() {
    sudo zypper packages --orphaned
}

clean_zypper() {
    sudo zypper clean --all
}