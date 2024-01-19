all: gtksourceview-wren.deb

gtksourceview-wren.deb: package/DEBIAN/control package/DEBIAN/postinst package/DEBIAN/preinst
	@dpkg-deb --build package
	@echo "Renaming 'package.deb' to 'gtksourceview-wren.deb'."
	mv package.deb gtksourceview-wren.deb

install:
	./INSTALL
.PHONY: install

clean:
	rm gtksourceview-wren.deb
.PHONY: clean

