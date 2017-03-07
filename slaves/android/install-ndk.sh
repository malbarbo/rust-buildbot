#!/bin/sh

set -ex

# Prep the Android NDK
#
# See https://github.com/servo/servo/wiki/Building-for-Android
curl -O https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip
unzip -q android-ndk-r13b-linux-x86_64.zip

# This tells the minimum android API version that we are targeting
API=21

android-ndk-r13b/build/tools/make_standalone_toolchain.py \
        --install-dir /android/ndk-arm \
        --arch arm \
        --api $API

android-ndk-r13b/build/tools/make_standalone_toolchain.py \
        --install-dir /android/ndk-aarch64 \
        --arch arm64 \
        --api $API

android-ndk-r13b/build/tools/make_standalone_toolchain.py \
        --install-dir /android/ndk-x86 \
        --arch x86 \
        --api $API

rm -rf ./android-ndk-r13b-linux-x86_64.zip ./android-ndk-r13b
