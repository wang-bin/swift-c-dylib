
MODULE_NAME=FooBar
SDK_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk
SWIFT_SRC=bar.swift
cc -c foo.c -o foo.o
swiftc ${SWIFT_SRC} -emit-module -module-name ${MODULE_NAME} -module-link-name ${MODULE_NAME} -import-objc-header foo.h
swiftc ${SWIFT_SRC} -c -module-name ${MODULE_NAME} -import-objc-header foo.h

echo ld -dylib foo.o ${SWIFT_SRC[@]//.swift/.o} -o lib${MODULE_NAME}.dylib -lSystem -syslibroot $SDK_DIR -L /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L $SDK_DIR/usr/lib/swift
swiftc -I. -L. main.swift