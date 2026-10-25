#!/usr/bin/env bash

detect_package_manager() {

	if command -v apt >/dev/null 2>&1; then
		# shellcheck disable=SC2034
		PACKAGE_MANAGER="apt"


	elif command -v dnf >/dev/null 2>&1; then
		# shellcheck disable=SC2034
		PACKAGE_MANAGER="dnf"

	elif command -v zypper >/dev/null 2>&1; then
		# shellcheck disable=SC2034
		PACKAGE_MANAGER="zypper"


	else
		echo "Unsupported distribution"
		exit 1
	fi
}
