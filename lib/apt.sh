#!/bin/bash

update_system() {
	sudo apt update
	sudo apt full-upgrade -y
	sudo apt autoremove -y
	sudo apt autoclean
}
