SHELL  := bash
stdout := /dev/null

help:
	@echo 'Commonly used make targets:'
	@echo '  fetch-repositories   - fetch repositories required for testing'
	@echo '  test                 - run tests'

test: run_tests clean

run_tests:
	@cd tests && python tests.py

clean:
	-@cd tests/repositories/bzr && bzr revert --no-backup &>$(stdout)
	-@cd tests/repositories/darcs && darcs revert -a &>$(stdout)
	-@cd tests/repositories/fossil && fossil revert &>$(stdout)
	-@cd tests/repositories/git && git reset -q --hard HEAD &>$(stdout)
	-@cd tests/repositories/hg && hg revert -a --no-backup &>$(stdout)
	-@cd tests/repositories/svn && svn revert -R . &>$(stdout)
	-@find . -name untracked_file -exec rm {} \;

fetch-bzr:
	@echo -n "Fetching Bazaar repository..."
	@if [ -d tests/repositories/bzr ]; then rm -rf tests/repositories/bzr; fi
	@bzr branch lp:vcprompt-quotes tests/repositories/bzr &>$(stdout)
	@echo "done."

fetch-darcs:
	@echo -n "Fetching Darcs repository..."
	@if [ -d tests/repositories/darcs ]; then rm -rf tests/repositories/darcs; fi
	@darcs get http://darcs.djl.im/quotes tests/repositories/darcs &>$(stdout)
	@echo "done."

fetch-fossil:
	@echo -n "Fetching Fossil repository..."
	@cd tests/repositories/fossil && fossil open fossil &>$(stdout)
	@echo "done."

fetch-git:
	@echo -n "Fetching Git repository..."
	@git submodule update --init &>$(stdout)
	@cd tests/repositories/git && git checkout master &>$(stdout)
	@echo "done."

fetch-hg:
	@echo -n "Fetching Mercurial repository..."
	@if [ -d tests/repositories/hg ]; then rm -rf tests/repositories/hg; fi
	@hg clone http://hg.djl.im/quotes tests/repositories/hg &>$(stdout)
	@echo "done."

fetch-svn:
	@echo -n "Fetching out SVN repository..."
	@if [ -d tests/repositories/svn ]; then rm -rf tests/repositories/svn; fi
	@svn checkout http://svn.github.com/djl/quotes.git tests/repositories/svn &>$(stdout)
	@echo "done."


fetch-repositories: fetch-bzr fetch-darcs fetch-fossil fetch-git fetch-hg fetch-svn

update-bzr:
	@echo -n "Updating Bazaar repository..."
	@cd tests/repositories/bzr && bzr pull &>$(stdout)
	@echo "done."

update-darcs:
	@echo -n "Updating Darcs repository..."
	@cd tests/repositories/darcs && darcs pull -a &>$(stdout)
	@echo "done."

update-git:
	@echo -n "Updating Git repository..."
	@git submodule update &>$(stdout)
	@echo "done."

update-hg:
	@echo -n "Updating Mercurial repository..."
	@cd tests/repositories/hg && hg pull -u
	@echo "done."

update-svn:
	@echo -n "Updating SVN repository..."
	@cd tests/repositories/svn && svn up
	@echo "done."

update-repositories: update-bzr update-darcs update-git update-hg update-svn

.PHONY: clean help run_tests test $(wildcard fetch-*) $(wildcard update-*)
