.PHONY: release

TYPE := patch
VERSION := $(shell semtag final -s $(TYPE) -o)

release:
	git checkout master
	git pull origin master
	@echo $(VERSION) | grep "ERROR" && exit 1 || true
	git-chglog -o CHANGELOG.md --next-tag $(VERSION)
	git add CHANGELOG.md
	git commit -m "chore(release): Update changelog for $(VERSION)"
	git tag $(VERSION)
	git push origin master --tags