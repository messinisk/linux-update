#!/usr/bin/env bash


info_dnf() {

    while true
    do
        echo
        echo "DNF Operations"
        echo
        echo "1) Update metadata"
        echo "2) Upgrade packages"
        echo "3) Remove unused packages"
        echo "4) Clean cache"
        echo "5) Exit"
        echo

        read -rp "Selection: " option

        case "$option" in

            1) update_dnf ;;
            2) upgrade_dnf ;;
            3) autoremove_dnf ;;
            4) clean_dnf ;;
            5) break ;;

            *) echo "Invalid selection" ;;

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
