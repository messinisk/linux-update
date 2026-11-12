#!/usr/bin/env bash


info_dnf() {

    while true
    do

        show_package_menu "DNF Operations"

        case "$?" in

            1) update_dnf ;;
            2) upgrade_dnf ;;
            3) autoremove_dnf ;;
            4) clean_dnf ;;
            5) break ;;

        esac

    done
}

update_dnf() {
    sudo dnf update
}

upgrade_dnf() {
    sudo dnf upgrade -y
}

autoremove_dnf() {
    sudo dnf autoremove -y
}

clean_dnf() {
    sudo dnf clean all
}
