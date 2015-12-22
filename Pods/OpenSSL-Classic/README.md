OpenSSL-Classic
=======

A fork of the OpenSSL-Universal project, which supports older, "classic", versions of iOS and Mac OS X. A CocoaPod for developers who target older operating systems and architectures.

Package comes with precompiled libraries, and includes a script to build newer versions, if necessary.

Current version contains binaries built with iOS SDK 7.1 (target iOS 4.0), and Mac OS X SDK 10.9 (target Mac OS X 10.6 Snow Leopard) for all supported architectures.

**Architectures**

- iOS with architectures: armv6, armv7, armv7s, arm64 + simulator (i386, x86_64)
- Mac OS X with architectures: i386, x86_64

**Why?**

[Apple says](https://developer.apple.com/library/mac/documentation/security/Conceptual/cryptoservices/GeneralPurposeCrypto/GeneralPurposeCrypto.html):
"Although OpenSSL is commonly used in the open source community, OpenSSL does not provide a stable API from version to version. For this reason, although OS X provides OpenSSL libraries, the OpenSSL libraries in OS X are deprecated, and OpenSSL has never been provided as part of iOS."

Specifically for this fork, a significant number of Mac OS X users are still using Snow Leopard and thus it is desirable to target this older OS. For my app, [Tunesify](http://www.tunesify.com), I could not use the existing CocoaPods for OpenSSL, which only support Mac OS X 10.7 Lion or later.

**Installation**

````
pod 'OpenSSL-Classic'
````

**Authors**

OpenSSL-Universal - [Marcin Krzyżanowski](https://twitter.com/krzyzanowskim)

OpenSSL-Classic fork - [Andrew Heard](http://www.wizheard.com)