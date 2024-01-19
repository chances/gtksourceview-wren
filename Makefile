all: build

SOURCES := $(shell find debian -type f)

build: $(SOURCES)
	@echo "Nothing to be done for 'build'."
.PHONY: build

gtksourceview-wren.deb: $(SOURCES)
	@dpkg-buildpackage -b -us -uc
	@dpkg-deb --build debian/gtksourceview-wren

check: gtksourceview-wren.deb
	@echo "Linting GitHub workflows."
	@`asdf which action-validator` .github/workflows/build.yml || true
	@`asdf which action-validator` .github/workflows/release.yml || true
	@echo "Linting Debian package."
	@echo lintian -i -I --show-overrides debian/gtksourceview-wren.deb
	@lintian -i -I --show-overrides debian/gtksourceview-wren.deb || true
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

