#!/bin/bash

update_system() {
	sudo zypper refresh
	sudo zypper dup -y
}
