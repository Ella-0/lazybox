pkgname=wayland-protocols
pkgver=1.20

fetch() {
	curl "https://wayland.freedesktop.org/releases/wayland-protocols-1.20.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure --prefix=/usr
	make
}

package() {
	cd $pkgname-$pkgver
	make DESTDIR=$pkgdir install
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
