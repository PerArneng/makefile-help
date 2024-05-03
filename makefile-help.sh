#
# generated @ 2024-05-03T10:08:06+0200
#
#
# `makefile-help.sh` is a shell script designed to extract and display help 
# information from Makefile targets. It generates a dynamically updated help 
# menu for users, detailing available targets and their purposes.
#
# Source:   https://github.com/PerArneng/makefile-help
# Author:   Per Arneng
# License:  MIT
#

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
printf "  \033[90mmakefile-help version: 0.1.2\033[0m\n\n"

exit 0
'''

# python section goes here

import sys


import re

class MakeTarget:
    def __init__(self, target, comment):
        self.target = target
        self.comment = comment

    def __repr__(self):
        return f"MakeTarget(target='{self.target}', comment='{self.comment}')"



def parse_makefile(file_path):
    # Regular expression to match targets and comments in the Makefile
    target_comment_pattern = re.compile(r'^(.+):.*?## (.*)$')
    
    # List to hold all MakeTarget instances
    targets = []
    
    # Open and read the Makefile
    with open(file_path, 'r') as file:
        for line in file:
            match = target_comment_pattern.match(line.strip())
            if match:
                # Extract the target and comment
                target, comment = match.groups()
                # Create a MakeTarget instance and add it to the list
                targets.append(MakeTarget(target, comment))
    
    return targets


class TargetGroup:
    def __init__(self, name, targets):
        self.name = name
        self.targets = targets
    
    def __repr__(self):
        return f"TargetGroup(name='{self.name}', targets={self.targets})"

def group_targets(targets):
    grouped = {}
    
    # Group targets based on the presence of a dash
    for target in targets:
        if '-' in target.target:
            group_name = target.target.split('-')[0]
        else:
            group_name = 'other'
        
        if group_name not in grouped:
            grouped[group_name] = []
        grouped[group_name].append(target)
    
    # Create TargetGroup instances and sort them
    target_groups = [TargetGroup(name, grouped[name]) for name in grouped]
    target_groups.sort(key=lambda x: (x.name == 'other', x.name))
    
    return target_groups

def make_bold(text):
    return f"\033[1m{text}\033[0m"

def make_blue(text):
    return f"\033[34m{text}\033[0m"


for arg in sys.argv[1:]:
    targets = parse_makefile(arg)
    grouped = group_targets(targets)
    make_file = make_blue(arg)
    print(f"{make_bold('Targets:')}")
    for group in grouped:
        group_name = make_bold(group.name)
        print(f"  {group_name}:")
        for target in group.targets:
            padded_target = make_blue(target.target.ljust(20)) 
            print(f"    {padded_target} {target.comment}")

print("\033[90mmakefile-help version: 0.1.2\033[0m")
