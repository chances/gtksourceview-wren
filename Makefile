all: gtksourceview-wren.deb

SOURCES := $(shell find package/DEBIAN -type f)

gtksourceview-wren.deb: $(SOURCES)
	@dpkg-deb --build package
	@echo "Renaming 'package.deb' to 'gtksourceview-wren.deb'."
	mv package.deb gtksourceview-wren.deb

install:
	./INSTALL
.PHONY: install

clean:
	rm gtksourceview-wren.deb
.PHONY: clean

