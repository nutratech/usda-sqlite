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
# Run, lint & format
# ---------------------------------------

.PHONY: run
run:
	pnpm dev

.PHONY: format
format:	## format SQL with pg_format
	./sql/format.sh

.PHONY: lint
lint:	## pnpm lint && pnpm check
	pnpm lint
	pnpm check



# ---------------------------------------
# Build & install
# ---------------------------------------

APP_VERSION ?= v$(shell jq -r .version package.json)
APP_BUNDLE ?= build-${APP_VERSION}.tar.xz
APP_RELEASE_DATE ?= $(shell date --iso)

.PHONY: build
build: clean
build:	## Build the release
	./sql/build.sh
	du -h ${APP_BUNDLE}

.PHONY: deploy/upload
deploy/upload:	## Upload to GitHub releases
	test -n "${APP_VERSION}"
	test -f ${APP_BUNDLE}
	gh release create ${APP_VERSION} --generate-notes
	gh release upload ${APP_VERSION} ${APP_BUNDLE}

.PHONY: deploy/delete
deploy/delete:
	gh release delete ${APP_VERSION}
	git push origin --delete ${APP_VERSION}
	- git tag -d ${APP_VERSION}


REMOTE_HEAD ?= origin/master

.PHONY: _check-git-up-to-date
_check-git-up-to-date:
	git branch --show-current
	git fetch
	# Check that we are in sync with ${REMOTE_HEAD}
	git diff --quiet ${REMOTE_HEAD}

PROJECT_NAME ?= web
DEPLOY_URL ?= https://nutra.tk/

.PHONY: deploy/install-prod
deploy/install-prod: _check-git-up-to-date
deploy/install-prod:	## Install (on prod VPS)
	# Check the version string was extracted from package.json
	test -n "${APP_VERSION}"
	# Download ${APP_VERSION}
	curl -sSLO https://github.com/nutratech/${PROJECT_NAME}/releases/download/${APP_VERSION}/${APP_BUNDLE}
	tar xf ${APP_BUNDLE}
	rm -f ${APP_BUNDLE}
	# Copy in place
	rm -rf /var/www/app/* && mv build/* /var/www/app/
	# Test live URL
	curl -fI ${DEPLOY_URL}



# ---------------------------------------
# Clean & extras
# ---------------------------------------

CLEAN_LOCS_ROOT ?= *.tar.xz build/

.PHONY: clean
clean:	## Clean up leftover bits and stuff from build
	rm -rf ${CLEAN_LOCS_ROOT}

.PHONY: purge
purge:	## Purge package-lock.json && node_modules/
	rm -rf package-lock.json pnpm-lock.yaml node_modules/

.PHONY: extras/cloc
extras/cloc:
	cloc HEAD --exclude-dir=svelte.config.js,pnpm-lock.yaml,package-lock.json
