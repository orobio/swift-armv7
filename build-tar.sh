#!/bin/bash
set -e
source swift-define

# Remove old
rm -rf $INSTALL_TAR
rm -rf $DEPLOYABLE_INSTALLDIR

# Create new
cp -a $SWIFT_INSTALL_PREFIX $DEPLOYABLE_INSTALLDIR
rm $DEPLOYABLE_INSTALLDIR/usr/swiftpm.json
GENERATE_TEMPLATE=1 ./generate-swiftpm-toolchain.sh
cp ${SWIFTPM_DESTINATION_FILE}.template $DEPLOYABLE_INSTALLDIR/usr/swiftpm.json.template

# Compress
cd $DEPLOYABLE_INSTALLDIR
tar -czvf $INSTALL_TAR .
