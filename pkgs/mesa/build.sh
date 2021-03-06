pkgname=mesa
pkgver=build-byacc
deps="musl:wayland:wayland-protocols:llvm:zlib:expat:libffi:libdrm"
ext=dev

fetch() {
	curl "https://gitlab.freedesktop.org/Ella-0/mesa/-/archive/build/byacc/mesa-build-byacc.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
	cp ../byacc-out-mid-build.patch .
	cp ../alpine-tls.patch .
	cp ../LICENSE .
	cd $pkgname-$pkgver
	patch -p1 < ../alpine-tls.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--prefix=/usr \
		-Dplatforms=wayland \
		-Ddri3=true \
		-Ddri-drivers=i915,i965 \
		-Dgallium-drivers=iris \
		-Dgallium-vdpau=false \
		-Dgallium-xvmc=false \
		-Dgallium-omx=disabled \
		-Dgallium-va=false \
		-Dgallium-xz=false \
		-Dgallium-nine=false \
		-Dgallium-opencl=disabled \
		-Dvulkan-drivers=intel \
		-Dvulkan-overlay-layer=true \
		-Dvulkan-device-select-layer=true \
		-Dshared-glapi=enabled \
		-Dgles1=false \
		-Dgles2=true \
		-Dopengl=true \
		-Dgbm=true \
		-Dglx=disabled \
		-Dglvnd=false \
		-Degl=true \
		-Dllvm=true \
		-Dshared-llvm=true \
		-Dvalgrind=false \
		-Dlibunwind=false \
		-Dlmsensors=false \
		-Dbuild-tests=false

	samu

#	NEEDED IF NOT USING A PATCHED BYACC
#	===================================
#	patch -p1 < ../../byacc-out-mid-build.patch
#	samu
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
	rm -r $pkgdir/usr/share
	rm -r $pkgdir/usr/bin
	rm $pkgdir/usr/lib/*.so
	rm $pkgdir/usr/lib/*.so.*
}

license() {
	cat LICENSE
}
