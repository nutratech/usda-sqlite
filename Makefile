SHELL=/bin/bash

.DEFAULT_GOAL := _help

# NOTE: must put a <TAB> character and two pound "\t##" to show up in this list.  Keep it brief! IGNORE_ME
.PHONY: _help
_help:
	@grep -h "##" $(MAKEFILE_LIST) | grep -v IGNORE_ME | sed -e 's/##//' | column -t -s $$'\t'



# ---------------------------------------
# Install requirements
# ---------------------------------------

.PHONY: init
init:	## Install requirements (w/o --frozen-lockfile)
	# Check version
	[[ "$(shell pnpm --version)" =~ "8." ]]
	# Remove old install
	rm -rf node_modules/
	# Install requirements
	pnpm install
	# Sync svelte kit (optional)
	pnpm svelte-kit sync



# ---------------------------------------
# Format
# ---------------------------------------

.PHONY: format
format:	## format SQL with pg_format
	# TODO: what about import.sql?  It gets formatted too ugly
	pg_format -L -s 2 -w 100 sql/tables.sql >sql/tables.fmt.sql
	mv sql/tables.fmt.sql sql/tables.sql\



# ---------------------------------------
# Build & install
# ---------------------------------------

DB_VERSION ?= $(shell python3 sql/latest_version.py)
DB_FILE ?= sql/dist/usda.sqlite3-${DB_VERSION}.tar.xz

.PHONY: build
build: clean
build:	## Build the release
	./sql/build.sh ${DB_VERSION}
	du -h ${DB_FILE}

.PHONY: deploy/upload
deploy/upload:	## Upload to GitHub releases
	test -n "${DB_VERSION}"
	test -f ${DB_FILE}
	gh release create v${DB_VERSION} --generate-notes
	gh release upload v${DB_VERSION} ${DB_FILE}

.PHONY: deploy/delete
deploy/delete:
	gh release delete v${DB_VERSION}
	git push origin --delete v${DB_VERSION}
	- git tag -d v${DB_VERSION}


REMOTE_HEAD ?= origin/master

.PHONY: _check-git-up-to-date
_check-git-up-to-date:
	git branch --show-current
	git fetch
	# Check that we are in sync with ${REMOTE_HEAD}
	git diff --quiet ${REMOTE_HEAD}

PROJECT_NAME ?= usda-sqlite

.PHONY: deploy/install-prod
deploy/install-prod: _check-git-up-to-date
deploy/install-prod:	## Install (on prod VPS)
	# Check the version string was extracted from package.json
	test -n "${DB_VERSION}"
	# Download ${DB_VERSION}
	curl -sSLO https://github.com/nutratech/${PROJECT_NAME}/releases/download/${DB_VERSION}/${DB_FILE}
	tar xf ${DB_FILE}



# ---------------------------------------
# Clean & extras
# ---------------------------------------

.PHONY: clean
clean:	## Clean up leftover bits and stuff from build
	rm -f sql/*.sqlite
	rm -f sql/*.sqlite3

.PHONY: extras/cloc
extras/cloc:
	cloc HEAD --exclude-dir=usda.svg
