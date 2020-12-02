# pch?
SDK_DIR := /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk
C_SRC := foo.c
C_OBJ := $(C_SRC:%.c=%.c.o)
SWIFT_OBJ := bar.o cat.o
SWIFT_SRC := $(SWIFT_OBJ:%.o=%.swift)
SWIFT_MODULE := $(SWIFT_OBJ:%.o=%.swiftmodule)

all: main

%.c.o: %.c
	cc -c $< -o $@

%.o: %.swift
	swift -frontend -parse-as-library -c -primary-file $< -emit-module-path $*.swiftmodule -emit-module-doc-path $*.swiftdoc -emit-module-source-info-path $*.swiftsourceinfo -module-name FooBar -import-objc-header foo.h -sdk $(SDK_DIR) -o $@

libFooBar.dylib: $(SWIFT_OBJ) $(C_OBJ)
	echo $(C_OBJ)
	swift -frontend -merge-modules $(SWIFT_MODULE) -emit-module -module-link-name FooBar -emit-module-doc-path FooBar.swiftdoc -emit-module-source-info-path FooBar.swiftsourceinfo -module-name FooBar -o FooBar.swiftmodule -sdk $(SDK_DIR)
	ld -dylib $^ -o $@ -lSystem -syslibroot $(SDK_DIR) -L /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L $(SDK_DIR)/usr/lib/swift

main: main.swift libFooBar.dylib
	swiftc -I. -L. $<

clean:
	rm -f *.dylib *.swiftmodule *.swiftsourceinfo *.swiftdoc *.o
