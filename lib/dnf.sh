#!/bin/bash

update_system() {
	sudo dnf update
	sudo dnf upgrade -y
}
