#!/bin/sh

set -ex

VERSION=1.0.2d

yum install -y setarch
curl http://openssl.org/source/openssl-$VERSION.tar.gz | tar xzf -
cp -r openssl-$VERSION openssl-static-64
cp -r openssl-$VERSION openssl-static-32
cd openssl-$VERSION
./config --prefix=/rustroot shared -fPIC
make -j10
make install

# Cargo is going to want to link to OpenSSL statically, so build OpenSSL
# statically for 32/64 bit
cd ../openssl-static-64
./config --prefix=/rustroot/cargo64 no-dso -fPIC
make -j10
make install

cd ../openssl-static-32
setarch i386 ./config --prefix=/rustroot/cargo32 no-dso -m32
make -j10
make install

ln -nsf /rustroot/cargo32 /home/rustbuild/root32
ln -nsf /rustroot/cargo64 /home/rustbuild/root64
yum erase -y setarch