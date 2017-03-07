#!/bin/sh

set -ex

# Prep the SDK and emulator
#
# Note that the update process requires that we accept a bunch of licenses, and
# we can't just pipe `yes` into it for some reason, so we take the same strategy
# located in https://github.com/appunite/docker by just wrapping it in a script
# which apparently magically accepts the licenses.

mkdir sdk
curl http://dl.google.com/android/android-sdk_r24.4-linux.tgz | \
    tar xzf - -C sdk --strip-components=1

# API 24 is the minimum to run arm64 emulator
# Note that this is the API level of the emulator, not the api of the NDK
# We can use an API for NDK that is less than or equal to this
API=24

filter="platform-tools,android-$API"
filter="$filter,sys-img-armeabi-v7a-android-$API"
filter="$filter,sys-img-arm64-v8a-android-$API"
filter="$filter,sys-img-x86-android-$API"

./accept-licenses.sh "android - update sdk -a --no-ui --filter $filter"

echo "no" | android create avd \
                --name arm-$API \
                --target android-$API \
                --abi armeabi-v7a

echo "no" | android create avd \
                --name aarch64-$API \
                --target android-$API \
                --abi arm64-v8a

echo "no" | android create avd \
                --name x86-$API \
                --target android-$API \
                --abi x86
