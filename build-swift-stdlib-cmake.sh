#!/bin/bash
set -e
source swift-define

echo "Create Swift build folder ${SWIFT_BUILDDIR}"
mkdir -p $SWIFT_BUILDDIR
mkdir -p $SWIFT_INSTALL_PREFIX

echo "Configure Swift"
rm -rf $SWIFT_BUILDDIR/CMakeCache.txt
LIBS="-latomic" cmake -S $SWIFT_SRCDIR -B $SWIFT_BUILDDIR -G Ninja \
		-DCMAKE_INSTALL_PREFIX=${SWIFT_INSTALL_PREFIX} \
		-DCMAKE_COLOR_MAKEFILE=OFF \
		-DBUILD_DOC=OFF \
		-DBUILD_DOCS=OFF \
		-DBUILD_EXAMPLE=OFF \
		-DBUILD_EXAMPLES=OFF \
		-DBUILD_TEST=OFF \
		-DBUILD_TESTS=OFF \
		-DBUILD_TESTING=OFF \
		-DBUILD_SHARED_LIBS=ON \
		-DCMAKE_BUILD_TYPE=${SWIFT_BUILD_CONFIGURATION} \
        -DCMAKE_C_COMPILER=$SWIFT_NATIVE_PATH/clang \
        -DCMAKE_CXX_COMPILER=$SWIFT_NATIVE_PATH/clang++ \
        -DCMAKE_C_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
        -DCMAKE_C_LINK_FLAGS="${LINK_FLAGS}" \
        -DCMAKE_CXX_LINK_FLAGS="${LINK_FLAGS}" \
		-DSWIFT_USE_LINKER=lld \
        -DLLVM_USE_LINKER=lld \
        -DLLVM_DIR=${LLVM_INSTALL_PREFIX}/lib/cmake/llvm \
        -DLLVM_BUILD_LIBRARY_DIR=${LLVM_INSTALL_PREFIX} \
        -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON \
        -DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=ON \
        -DSWIFT_NATIVE_CLANG_TOOLS_PATH=$SWIFT_NATIVE_PATH \
        -DSWIFT_NATIVE_SWIFT_TOOLS_PATH=$SWIFT_NATIVE_PATH \
        -DSWIFT_BUILD_AST_ANALYZER=OFF \
        -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=ON \
        -DSWIFT_BUILD_DYNAMIC_STDLIB=ON \
        -DSWIFT_BUILD_REMOTE_MIRROR=OFF \
        -DSWIFT_BUILD_SOURCEKIT=OFF \
        -DSWIFT_BUILD_STDLIB_EXTRA_TOOLCHAIN_CONTENT=OFF \
        -DSWIFT_BUILD_SYNTAXPARSERLIB=OFF \
        -DSWIFT_BUILD_REMOTE_MIRROR=OFF \
        -DSWIFT_ENABLE_SOURCEKIT_TESTS=OFF \
        -DSWIFT_INCLUDE_DOCS=OFF \
        -DSWIFT_INCLUDE_TOOLS=OFF \
        -DSWIFT_INCLUDE_TESTS=OFF \
        -DSWIFT_LIBRARY_EVOLUTION=0 \
        -DSWIFT_RUNTIME_OS_VERSIONING=OFF \
        -DSWIFT_HOST_VARIANT_ARCH=$SWIFT_TARGET_ARCH \
        -DSWIFT_SDKS=LINUX \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_PATH=${STAGING_DIR}  \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_LIBC_INCLUDE_DIRECTORY=${STAGING_DIR}/usr/include  \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_LIBC_ARCHITECTURE_INCLUDE_DIRECTORY=${STAGING_DIR}/usr/include/arm-linux-gnueabihf \
        -DSWIFT_LINUX_${SWIFT_TARGET_ARCH}_ICU_I18N=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicui18n.so \
        -DSWIFT_LINUX_${SWIFT_TARGET_ARCH}_ICU_UC=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicuuc.so \
        -DICU_I18N_LIBRARIES=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicui18n.so \
        -DICU_UC_LIBRARIES=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicuuc.so \
        -DZLIB_LIBRARY=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libz.so \
        -DZLIB_INCLUDE_DIR=${STAGING_DIR}/usr/include \
        -DSWIFT_PATH_TO_LIBDISPATCH_SOURCE=${LIBDISPATCH_SRCDIR} \
        -DSWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY=ON \
		-DCMAKE_Swift_FLAGS_DEBUG="" \
		-DCMAKE_Swift_FLAGS_RELEASE="" \
		-DCMAKE_Swift_FLAGS_RELWITHDEBINFO="" \
        -DCMAKE_OSX_SYSROOT="" \

echo "Build Swift StdLib"
(cd $SWIFT_BUILDDIR && ninja)

echo "Install Swift StdLib"
(cd $SWIFT_BUILDDIR && ninja install)

echo "Install to Debian sysroot"
cp -rf ${SWIFT_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/