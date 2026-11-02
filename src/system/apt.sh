#!/usr/bin/env bash

###############################################################################
# Information
###############################################################################

info_apt() {

    while true
    do

        echo
        echo "APT Operations"
        echo
        echo "1) Update package lists"
        echo "2) Upgrade packages"
        echo "3) Remove unused packages"
        echo "4) Clean package cache"
        echo "5) Exit"
        echo

        read -rp "Selection: " option

        case "$option" in

            1)
                update_apt
                ;;

            2)
                upgrade_apt
                ;;

            3)
                autoremove_apt
                ;;

            4)
                autoclean_apt
                ;;

            5)
                break
                ;;

            *)
                echo
                echo "Invalid selection"
                ;;

        esac

    done
}

###############################################################################
# Update metadata
###############################################################################

update_apt() {
    sudo apt update
}

###############################################################################
# Upgrade packages
###############################################################################

upgrade_apt() {
    sudo apt full-upgrade
}

###############################################################################
# Remove unused dependencies
###############################################################################

autoremove_apt() {
    sudo apt autoremove
}

###############################################################################
# Clean package cache
###############################################################################

autoclean_apt() {
    sudo apt autoclean
}
