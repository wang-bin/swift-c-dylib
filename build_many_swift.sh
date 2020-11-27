
MODULE_NAME=FooBar
SDK_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk
SWIFT_SRC=(bar.swift cat.swift)
cc -c foo.c -o foo.o
for s in ${SWIFT_SRC[@]}; do
    swift -frontend -parse-as-library -c -primary-file $s -emit-module-path ${s%.*}.swiftmodule -emit-module-doc-path ${s%.*}.swiftdoc -emit-module-source-info-path ${s%.*}.swiftsourceinfo -module-name ${MODULE_NAME} -import-objc-header foo.h -sdk $SDK_DIR -o ${s%.*}.o
done

swift -frontend -merge-modules ${SWIFT_SRC[@]//.swift/.swiftmodule} -emit-module -module-link-name ${MODULE_NAME} -emit-module-doc-path ${MODULE_NAME}.swiftdoc -emit-module-source-info-path  ${MODULE_NAME}.swiftsourceinfo  -module-name ${MODULE_NAME} -o ${MODULE_NAME}.swiftmodule -sdk $SDK_DIR

ld -dylib foo.o ${SWIFT_SRC[@]//.swift/.o} -o lib${MODULE_NAME}.dylib -lSystem -syslibroot $SDK_DIR -L /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L $SDK_DIR/usr/lib/swift

swiftc -I. -L. main.swift