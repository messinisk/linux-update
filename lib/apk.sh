#!/usr/bin/env bash

update_system() {
	apk update && apk upgrade
}
