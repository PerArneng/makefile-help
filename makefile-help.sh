#!/bin/sh

# makefile-help.sh
#
# This script is designed to extract and display help information from Makefile targets that are documented
# according to a specific convention. It is intended to be invoked from a Makefile to provide a dynamically
# generated help menu for users, detailing available targets and their purposes.
#
# Author: Per Arneng
# License: MIT
# Source Repo: https://github.com/PerArneng/makefile-help
#
# Usage:
#   To integrate this script into a Makefile, include it in your project directory and add the following:
#
#   .PHONY: help
#   help: ## Display this help.
#       @bash makefile-help.sh $(MAKEFILE_LIST)
#
#   Target documentation should follow the format:
#       <target-name>: ## <description>
#   For example:
#       build: ## Compile the project.
#
#   If you include a dash ('-') in the target name, the part before the first dash is treated as a group
#   label. Targets under the same group will be listed together under that group name. If no group is
#   specified, targets will be listed under the 'Other' category.
#
# Requirements:
#   - grep
#   - A POSIX-compliant shell
#
# Error Handling:
#   If no arguments (makefiles) are provided, the script will display an error message and exit with a
#   status of 1.


# Check if no arguments are provided
if [ "$#" -eq 0 ]; then
    printf "%s: error: no makefiles provided\n" "$(basename "$0")"
    printf "%s: error: please read the script documentation for usage instructions\n" "$(basename "$0")"
    exit 1
fi

# Function to print help information extracted from a Makefile
print_help() {
    local makefile=$1
    local current_group=""
    local IFS
    local other_printed=false

    printf "Usage: make [target] ...\n"
    printf "Targets:\n"

    grep -E '^[a-zA-Z0-9_-]+:.*?## .*' "$makefile" | while IFS=':' read -r target deps; do
        case "$deps" in
            *'##'*)
                local help="${deps##*##}"
                help="${help#"${help%%[![:space:]]*}"}"

                if echo "$target" | grep -q '-'; then
                    local group="${target%%-*}"
                else
                    local group="Other"
                    if [ "$other_printed" = false ]; then
                        printf "  Other:\n"
                        other_printed=true
                    fi
                fi

                target="${target#"${target%%[![:space:]]*}"}"
                target="${target%%[[:space:]]*}"

                if [ "$group" != "$current_group" ] && [ "$group" != "Other" ]; then
                    printf "  %s:\n" "$group"
                    current_group="$group"
                fi

                printf "    \033[34m%-25s\033[0m %s\n" "$target" "$help"
                ;;
        esac
    done
}

# Process each Makefile passed as an argument
for makefile in "$@"; do
    if [ -f "$makefile" ]; then
        printf "\n"
        printf "Help for %s:\n" "$makefile"
        print_help "$makefile"
        printf "\n"
    else
        printf "%s: error: '%s' is not a valid file.\n" "$(basename "$0")" "$makefile"
    fi
done
