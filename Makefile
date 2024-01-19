all: build

SOURCES := $(shell find data -type f) $(shell find src -type f)

build: $(SOURCES)
	@echo "Nothing to be done for 'build'."
.PHONY: build

debian/gtksourceview-wren.deb: $(SOURCES)
	@dpkg-buildpackage -b -us -uc
	@dpkg-deb --build debian/gtksourceview-wren

check: check-workflows debian/gtksourceview-wren.deb
	@echo "Linting Wren language syntax."
	@jing /usr/share/gtksourceview-3.0/language-specs/language2.rng data/language-specs/wren.lang || true
	@echo "Linting Debian package."
	@echo lintian -i -I --show-overrides debian/gtksourceview-wren.deb
	@lintian -i -I --show-overrides debian/gtksourceview-wren.deb || true
.PHONY: check

check-workflows: $(shell find .github/workflows -type f)
	@echo "Linting configs using yamllint ($(shell yamllint --version | cut -d" " --fields=2))."
	yamllint .github/release-drafter.yml || true
	@echo "Linting GitHub workflows using action-validator ($(shell `asdf which action-validator` --version | cut -d" " --fields=2))."
	@`asdf which action-validator` .github/workflows/build.yml || true
	@`asdf which action-validator` .github/workflows/release.yml || true
.PHONY: check

distcheck: check
	@echo "Testing installation and removal."
	@./INSTALL
	@sudo dpkg -r gtksourceview-wren
	@echo "Testing installation and removal (via purge)."
	@./INSTALL
	@sudo dpkg -P gtksourceview-wren
.PHONY: distcheck

install:
	mkdir -p $(DESTDIR)/DEBIAN
# See https://superuser.com/a/216920/214545
	cp -Lr `pwd`/src/* $(DESTDIR)/.
.PHONY: install

clean:
# TODO: @clean_dh_auto
	rm -rf debian/gtksourceview-wren/
	rm -f debian/gtksourceview-wren.deb
	rm -f debian/gtksourceview-wren_0.1.changes
#	rm -f src/usr/share/doc/gtksourceview-wren/changelog.gz
#	rm -f src/usr/share/doc/gtksourceview-wren/copyright
.PHONY: clean

