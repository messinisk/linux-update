#!/usr/bin/env bash

update_system() {
	sudo apt update
	sudo apt full-upgrade 
	sudo apt autoremove 
	sudo apt autoclean
}
