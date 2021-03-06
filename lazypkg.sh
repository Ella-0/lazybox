#!/bin/sh
export JOBS="16"

export RUSTFLAGS="-C target-feature=-crt-static"
export CC=clang
export CXX=clang++

stat /etc/lazypkg.conf > /dev/null 2> /dev/null || . /etc/lazypkg.conf

export SAMUFLAGS=-j$JOBS
export MAKEFLAGS=-j$JOBS

. ./build.sh
dir=$(pwd)
stat out > /dev/null && rm -rf out
mkdir out

function do_fetch() {
	mkdir -p src
	cd src
	srcdir=$(pwd) fetch
}

srcdir=$(pwd)/src
stat src > /dev/null 2>/dev/null || do_fetch

cd $srcdir

build
cd $srcdir

echo "
. $dir/build.sh
mkdir -p $dir/out/$pkgname
pkgdir=$dir/out/$pkgname package


mkdir -p $dir/out/$pkgname/usr/share/lazypkg

cat > $dir/out/$pkgname/usr/share/lazypkg/$pkgname << EOF
[pkg]
name=$pkgname
ver=$pkgver
deps=$deps

[license]
EOF

chmod 644 $dir/out/$pkgname/usr/share/lazypkg/$pkgname
cd $srcdir
license >> $dir/out/$pkgname/usr/share/lazypkg/$pkgname

echo >> $dir/out/$pkgname/usr/share/lazypkg/$pkgname
echo [fs] >> $dir/out/$pkgname/usr/share/lazypkg/$pkgname

cd $dir/out/$pkgname/
find * >> $dir/out/$pkgname/usr/share/lazypkg/$pkgname

cd $dir/out/$pkgname
tar -cf ../$pkgname.$pkgver.tar.xz *
if [ $ext ]; then

echo $ext | tr ':' '\n' | while read e; do
	echo \$e

    cd $srcdir
    mkdir -p $dir/out/$pkgname-\$e
    pkgdir=$dir/out/$pkgname-\$e

    package_\$(echo \$e | tr '-' '_')

    mkdir -p $dir/out/$pkgname-\$e/usr/share/lazypkg

    cat > $dir/out/$pkgname-\$e/usr/share/lazypkg/$pkgname-\$e << EOF
[pkg]
name=$pkgname-\$e
ver=$pkgver
deps=$pkgname

[license]
EOF

    chmod 644 $dir/out/$pkgname-\$e/usr/share/lazypkg/$pkgname-\$e
    cd $srcdir
    license >> $dir/out/$pkgname-\$e/usr/share/lazypkg/$pkgname-\$e

    echo >> $dir/out/$pkgname-\$e/usr/share/lazypkg/$pkgname-\$e
    echo [fs] >> $dir/out/$pkgname-\$e/usr/share/lazypkg/$pkgname-\$e

    cd $dir/out/$pkgname-\$e

    find * >> $dir/out/$pkgname-\$e/usr/share/lazypkg/$pkgname-\$e

    cd $dir/out/$pkgname-\$e
    tar -cf ../$pkgname-\$e.$pkgver.tar.xz *

done

fi


" | sh
cd $dir
