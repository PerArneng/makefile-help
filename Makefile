

.PHONY: build-script
build-script: ## builds the final script file out of the sections
	@echo "building final script"
	@printf "#\n# generated @ $$(date '+%Y-%m-%dT%H:%M:%S%z')\n#\n" > makefile-help.sh
	@cat src/section-head.sh >> makefile-help.sh
	@cat src/section-shell.sh >> makefile-help.sh
	@cat src/section-python.py >> makefile-help.sh
	@sed -i '' 's/__VERSION__/0.1.1/g' makefile-help.sh


.PHONY: help
help: ## runs the makefile-help.sh script
	@sh makefile-help.sh $(MAKEFILE_LIST)


