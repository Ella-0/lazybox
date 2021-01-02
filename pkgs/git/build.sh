pkgver=2.30.0
pkgname=git
pkgrel=1
bad="gmake"
ext="doc"

fetch() {
	curl -L "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.0.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	gmake NO_PERL=1 NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_MSGFMT_EXTENDED_OPTIONS=1 prefix=/ INSTALL_SYMLINKS=1
	# Need to run twice for it to work ¯\_(ツ)_/¯
	# Some issue with `msgfmt` 'cause I'm using gettext-tiny but idk why it works on the second run
	gmake NO_PERL=1 NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_MSGFMT_EXTENDED_OPTIONS=1 prefix=/ INSTALL_SYMLINKS=1
}

package() {
	cd $pkgname-$pkgver
	gmake NO_PERL=1 NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_MSGFMT_EXTENDED_OPTIONS=1 install prefix=/ DESTDIR=$pkgdir INSTALL_SYMLINKS=1
}

package_doc() {
	gmake NO_PERL=1 NO_REGEX=NeedsStartEnd NO_TCLTK=1 NO_MSGFMT_EXTENDED_OPTIONS=1 install-man prefix=/ DESTDIR=$pkgdir INSTALL_SYMLINKS=1
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
