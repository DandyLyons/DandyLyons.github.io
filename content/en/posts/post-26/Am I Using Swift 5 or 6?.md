---
title: 'Am I Using Swift 5 or 6?'
slug: am-i-using-swift-5-or-6
date: 2024-11-19
topics: ["Swift 6"]
description: 
---

Swift is in the middle of a transition from Swift 5 to Swift 6. This transition is not as simple as it may seem. In this post, we will discuss how to determine which version of Swift you are using. But first we need to clear up some misconceptions. 

1. We need to understand the difference between Swift 6 **the compiler** and Swift 6 **the language mode**. 
2. We need to understand how to determine which version of the Swift **compiler** we are using.
3. We need to understand how to determine which version of the Swift **language mode** we are using.
4. We need to understand how to opt in or out of Swift 5 or Swift 6 **language mode**.

> **Note:** This post will be primarily concerned with the native Swift Package Manager. Xcode has been known to behave slightly differently than SPM, and this post does not exhaustively cover all the ways Xcode may differ. This post assumes that you know how to use SPM and particularly how to declare a Swift Package using a `Package.swift` file. If you are not familiar with this, I recommend reading the [Swift Package Manager Documentation](https://swift.org/package-manager/).

## What's The Difference Between The Compiler and The Language Mode
Swift updates its language using semantic versioning. This means that each minor release (for example from 5.9 to 5.10) is a non-breaking change, and each major release (for example from 5 to 6) is a breaking change. A non-breaking change means that code written in the previous version of Swift will compile and run in the new version of Swift. A breaking change means that code written in the previous version of Swift will not compile in the new version of Swift.

>Don't forget that in Swift, the compiler will refuse to compile code that has a compiler **Error**. But if you have a **Warning**, it will still compile. 

But Swift is also backwards compatible with prior versions of Swift. This means, for example that code written in Swift 5 can be compiled with the Swift 6 compiler. Swift 5 code can also call Swift 6 code, and vice versa. So how does this work? How can they be compatible if a major release is a breaking change. At least part of the answer is by using a Swift compiler feature called **language mode**. 

>Note: Swift appears to have recently changed the name of this feature from **language versions** to **language modes**. You can see this in the Swift Package Manager API. (See the docs [here](https://developer.apple.com/documentation/packagedescription/package/init(name:defaultlocalization:platforms:pkgconfig:providers:products:dependencies:targets:swiftlanguageversions:clanguagestandard:cxxlanguagestandard:))). I welcome this change as "language version" was easier to confuse with the compiler version. Pay extra attention whenever you see the term "language version" in the Swift documentation or tooling. Ask yourself if it is referring to the Swift compiler version or the Swift language mode.

The takeaway that I want you to get is this: **Each Swift compiler can compile syntax from earlier versions of Swift**. This is done by setting the **language mode**. The compiler version determines the Swift language features that are available to you on your machine. The language mode determines which Swift syntax and language features you would like to use in each target. 

## How To Determine Which Version of The Swift Compiler You Are Using
Now that we understand the difference between the Swift compiler and the Swift language mode, let's talk about how to determine which version of the Swift compiler you are using. Open terminal and type in the following command:

```bash
swift --version
```

If you have Swift installed on your machine, then you should see something like this:

```bash
swift-driver version: 1.115 Apple Swift version 6.0 (swiftlang-6.0.0.9.10 clang-1600.0.26.2)
Target: arm64-apple-macosx15.0
```

This shows you the tooling version of the Swift compiler. In this case, it is Swift 6.0. 

## How To Determine Which Version of The Swift Language Mode You Are Using
Now that we know how to determine which version of the Swift compiler we are using, let's talk about how to determine which version of the Swift language mode we are using. 

Swift allows us to mix and match Swift 6 code with prior versions. At present, the Swift 6 compiler can use the following language modes:
- Swift 6
- Swift 5
- Swift 4.2
- Swift 4

The Swift documentation states [here](https://arc.net/l/quote/rrrnddoa) that the default language mode is Swift 5. This means that if you do not specify a language mode, then the Swift 6 compiler will use the Swift 5 language mode. While true in principle, I have found that this is not quite so intuitive in practice. 

### Using Swift 5 Language Mode In The Swift 6 Compiler
Quick refresher on `Package.swift` files. At the top of every `Package.swift` file, you will see a declaration like this:

```swift
// swift-tools-version:6.0
```

Be advised. Even though this is written as a comment, it is not a comment. It is a directive to the Swift Package Manager. This directive tells the Swift Package Manager the minimum version of the Swift compiler to use. If you have `swift-tools-version:6.0`, then the Swift Package Manager must use the Swift 6 compiler. (We'll see why this is important in a moment.)

To specify the language mode in a target, you can do so like this:

```swift
.target(name: "MyTarget",
  dependencies:[.fancyLibrary],
  swiftSettings: [
    .swiftLanguageMode(.v5)
  ]
)
```

This tells the Swift 6 compiler to use the Swift 5 language mode for the target `MyTarget`. But according to the docs this should be unnecessary. Remember that the default language mode is Swift 5. So let's leave it out since it is redundant.

```swift
.target(name: "MyTarget",
  dependencies:[.fancyLibrary],
  swiftSettings: []
)
```

It turns out that we are now using the Swift 6 language mode. Why? According to the docs: 

>A `Package.swift` file that uses `swift-tools-version` of 6.0 will enable the Swift 6 language mode for all targets. You can still set the language mode for the package as a whole using the `swiftLanguageModes` property of `Package`. See [docs](https://arc.net/l/quote/yqrnbxcw). 

In other words, the **Swift 5 language mode** is indeed opt-in, but only if you are using `// swift-tools-version:5.10`[^1]. But as soon as you use `// swift-tools-version:6.0`, you are using the Swift 6 language mode, by default. To make matters more confusing when you create a new Swift Package[^2], the Swift Package Manager will default to `// swift-tools-version:6.0`.

[^1]: Or any other version of Swift 5.
[^2]: Using `swift package init` or by clicking **File > New Package** inside Xcode.

### Using `swift-tools-version:5.x` In The Swift 6 Compiler
You are of course allowed to use `swift-tools-version:5.10` and earlier in the Swift 6 compiler, but now there are even more gotchas to be aware of. In particular, the `PackageDescription` API has changed between Swift 5 and Swift 6. This means that you will need to use the Swift 5 version of the `PackageDescription` API. 

One of the biggest differences between the two APIs is that in the Swift 5 `PackageDescription` API, **you cannot declare a language mode at a per-target level**. Instead, you must declare the language mode at the package level, meaning all of your targets must use the same language mode. (Per target language mode was introduced in [SE-0435](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0435-swiftpm-per-target-swift-language-version-setting.md) and there doesn't appear to be a way to use this feature in Swift 5 with an upcoming feature flag.) 

So in short, while it may be technically true that the Swift 6 language mode is opt-in, this isn't really accurate when it comes to SPM. If you are using `// swift-tools-version:6.0` then the Swift 6 language mode is the default. 

## Using Swift 6 Features In Swift 5 Language Mode
Thankfully, both the Swift 5 and Swift 6 compiler allow you to use Swift 6 features. You can even use Swift 6 features when using the Swift 5 language mode! This is done by enabling upcoming features. Be sure to read this official Swift blog post on [Using Upcoming Feature Flags](https://www.swift.org/blog/using-upcoming-feature-flags/). 

To enable upcoming features in a Swift Package, define your target like so: 

```swift
.target(name: "MyTarget",
  dependencies:[.fancyLibrary],
    swiftSettings:
      [.enableUpcomingFeature("ConciseMagicFile"),
       .enableUpcomingFeature("BareSlashRegexLiterals"),
       .enableUpcomingFeature("ExistentialAny")])
 ```

Here is a list of [Swift 6 features](https://www.swift.org/migration/documentation/swift-6-concurrency-migration-guide/sourcecompatibility/) from the Swift 6 documentation. To enable a feature, open the features Swift Evolution proposal (e.g. [SE-0337](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0337-support-incremental-migration-to-concurrency-checking.md)), then look for the **Upcoming Feature Flag**. This is the string that you will be using. Then add it to your target like in the example above. Now you can use Swift 6 features in your Swift 5 code! Even better you can pick and choose which features you are ready to use. This is perfect for incremental migration.

## So Many Options. Which Should I Choose? 
While it may be frustrating to encounter these rough edges, it is important to remember that change is good. Strict concurrency checking has the potential to eliminate entire classes of bugs which would be a huge benefit for the whole world.[^3] But it's important to acknowledge that change is also painful. This is hard, and if you are struggling, then that is okay. This is not the first time that Swift has had a difficult transition and it won't be the last. 

[^3]: I'm not being hyperbolic here. Concurrency bugs are some of the most difficult to debug and can be some of the most difficult to reproduce. Eliminating these bugs would be a huge positive for society at large.

But thankfully, the Swift 6 compiler gives us a lot of tools to help us through this transition. We can use the Swift 5 language mode to keep our code running while we incrementally adopt Swift 6 features. We can use upcoming feature flags to pick and choose which features we are ready to use. Finally, when we are ready, we can use the Swift 6 language mode to get the full benefits of the new Swift 6 features.

Take full advantage of these tools. They are there to help you. And don't feel like you need to adopt the latest and greatest right now. You should take your time and adopt these features at your own pace.

## Bonus: Easily Enable Upcoming Features Using Static Strings
I like to finish my posts with a little "birthday present" for you. Here is a gist that you can add to any `Package.swift` file. This will allow you to easily enable upcoming features using static strings. Please feel free to fork, clone and contribute the rest of the upcoming feature flags from the [docs](https://www.swift.org/migration/documentation/swift-6-concurrency-migration-guide/sourcecompatibility/).

<script src="https://gist.github.com/DandyLyons/56dc43d0b98befa670758490b43fff07.js"></script>

---
## Recommended Reading
- [Migrating to Swift 6 | Documentation](https://www.swift.org/migration/documentation/migrationguide)
  - [Enabling The Swift 6 Language Mode | Documentation](https://www.swift.org/migration/documentation/swift-6-concurrency-migration-guide/swift6mode)
  - [Incremental Adoption | Documentation](https://www.swift.org/migration/documentation/swift-6-concurrency-migration-guide/incrementaladoption) 
- [Swift.org - Using Upcoming Feature Flags](https://www.swift.org/blog/using-upcoming-feature-flags/) 
- [Migrate your app to Swift 6 - WWDC24 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2024/10169/) 