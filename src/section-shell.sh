#!/bin/sh

''':'
# Check if Python is available
if command -v python >/dev/null 2>&1; then
    # Rerun this script with Python
    exec python "$0" "$@"
    exit 0
elif command -v python3 >/dev/null 2>&1; then
    # Rerun this script with Python3 if Python3 is available
    exec python3 "$0" "$@"
    exit 0
fi
awk 'BEGIN {FS = ":.*?## "; printf "\n  \033[1mTargets:\033[0m\n"} /^[a-zA-Z_-]+:.*?## / {printf "    \033[36m%-30s\033[0m %s\n", $1, $2}' $@
printf "\n  \033[1mPro Tip:\033[0m \033[90minstall python for a better help experience!\033[0m\n"
printf "  \033[90mmakefile-help version: __VERSION__\033[0m\n\n"

exit 0
'''

# python section goes here

