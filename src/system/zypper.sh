#!/usr/bin/env bash

info_zypper(){
	while true
    do
        echo
        echo "zypper Operations"
        echo
        echo "1) Update metadata"
        echo "2) Upgrade packages"
        echo "3) Remove unused packages"
        echo "4) Clean cache"
        echo "5) Exit"
        echo

        read -rp "Selection: " option

        case "$option" in

            1) update_zypper ;;
            2) upgrade_zypper ;;
            3) autoremove_zypper ;;
            4) clean_zypper ;;
            5) break ;;

            *) echo "Invalid selection" ;;

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