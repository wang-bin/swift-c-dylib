cc -c foo.c
swiftc bar.swift -import-objc-header foo.h -emit-library -emit-module -module-name FooBar -module-link-name FooBar foo.o
swiftc -I. -L. main.swift