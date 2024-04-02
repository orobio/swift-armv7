#!/bin/sh

set -o nounset
set -o errexit

DEPLOY_DIR=/opt/swift-armv7-sysroot
BASE_SYSROOT_URL=https://github.com/colemancda/swift-armv7/releases/download/0.4.0/bullseye-armv7.tar
BASE_SYSROOT_FILE=/opt/bullseye-armv7.tar
SWIFT_ARMV7_FILE=/opt/swift-armv7.tar.gz # Must exist

# Download
echo "Download bullseye-armv7.tar"
wget -q $BASE_SYSROOT_URL -O $BASE_SYSROOT_FILE

# Deploy
mkdir -p $DEPLOY_DIR
tar -xf $BASE_SYSROOT_FILE -C $DEPLOY_DIR --strip-components 2
tar -xf $SWIFT_ARMV7_FILE -C $DEPLOY_DIR
sed "s,@SYSROOT@,$DEPLOY_DIR,g" $DEPLOY_DIR/usr/swiftpm.json.template > $DEPLOY_DIR.json

# Clean-up
rm -rf $BASE_SYSROOT_FILE
rm -rf $SWIFT_ARMV7_FILE
rm -f /opt/deploy.sh # This script
