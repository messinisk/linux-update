#!/usr/bin/env bash

show_package_menu() {

    local title="$1"

    while true
    do

        echo
        echo "$title"
        echo

        echo "1) Update package lists"
        echo "2) Upgrade packages"
        echo "3) Remove unused packages"
        echo "4) Clean package cache"
        echo "5) Back"
        echo

        read -rp "Selection: " option

        case "$option" in

            1|2|3|4|5)
                # shellcheck disable=SC2034
                MENU_SELECTION="$option"
                return 0
                ;;

            *)
                echo
                echo "Invalid selection"
                ;;

        esac

    done
}

show_main_menu() {

    while true
    do

        echo
        echo "linux-update"
        echo

        echo "1) Package Manager Operations"
        echo "2) Self Update"
        echo "3) Version Information"
        echo "4) Verify Installation"
        echo "5) Exit"
        echo

        read -rp "Selection: " option

        case "$option" in

            1|2|3|4|5)
                MENU_SELECTION="$option"
                return 0
                ;;

            *)
                echo "Invalid selection"
                ;;

        esac

    done
} 

show_selfupdate_menu() {

    while true
    do

        echo
        echo "Self Update"
        echo

        echo "1) Check for updates"
        echo "2) Back"
        echo

        read -rp "Selection: " option

        case "$option" in

            1|2)
                # shellcheck disable=SC2034
                MENU_SELECTION="$option"
                return 0
                ;;

            *)
                echo "Invalid selection"
                ;;

        esac

    done
}