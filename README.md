# makefile-help.sh

## Overview

`makefile-help.sh` is a shell script designed to extract and display help 
information from Makefile targets. It generates a dynamically updated help 
menu for users, detailing available targets and their purposes.

## Author

Per Arneng

## Licence

MIT

## Usage

To use this script, include it in your project directory and add the 
following to your Makefile:

```makefile
.PHONY: help
help: ## Display this help.
    @sh makefile-help.sh $(MAKEFILE_LIST)
```

## Target Documentation Format
Document your Makefile targets in the following format:

```makefile
<target-name>: ## <description>
```

For example:

```makefile
build: ## Compile the project.
```

If a target name includes a dash ('-'), the part before the first dash is
treated as a group label. Targets under the same group will be listed
together under that group name. If no group is specified, targets will be
listed under the 'Other' category.

## Requirements
* grep
* A POSIX-compliant shell

## Example
Here is how help information will be displayed when you run make help:

```basic
Copy
Usage: make [target] ...
Targets:
  other:
    clean          Remove all build files.
  build:
    build-project  Compile the project.
```
