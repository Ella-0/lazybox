pkgname=wlroots
pkgver=0.12.0
ext="dev"

fetch() {
	curl -L "https://github.com/swaywm/wlroots/releases/download/0.12.0/wlroots-0.12.0.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	rm -r $pkgdir/usr/include
	rm -r $pkgdir/usr/lib/pkgconfig
}

package_dev() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	rm $pkgdir/usr/lib/*.so
	rm $pkgdir/usr/lib/*.so.*
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
