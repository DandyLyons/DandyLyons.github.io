---
date: 2024-09-24
title: Swift 6's New @retroactive Attribute
slug: swift-6-retroactive-attribute
images: [""]
description: Learn about retroactive protocol conformance, and why you probably shouldn't use it on external types. 
topics: [Swift]
---

# Swift 6's New `@retroactive` Attribute

Swift 6.0 introduced the `@retroactive` attribute to address a specific issue with protocol conformances. Here's what you need to know:

## The Problem

Suppose you are using a type from an external library and realize that the type does not conform to a protocol such as `Codable`. You might be tempted to add your own conformance.

```swift
import ExternalLibrary
extension ExternalType: Codable {
    // implementation here
}
```

However, doing this can be quite problematic. What happens if the library owner later adds their own conformance? Which code will execute? Your conformance or their conformance? The answer is that the behavior will be undefined at runtime, since we don't know which conformance will "win". Even worse, this same problem will propagate to every library that imports your library.[^1]

[^1]: There are a few exceptions to the this which you can find [here](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0364-retroactive-conformance-warning.md#detailed-design) and [here](https://forums.swift.org/t/amendment-se-0364-allow-same-package-conformances/71877). 

## The Solution: `@retroactive`

To combat this problem, Swift 6.0 now emits a warning any time you retroactively add a conformance to an external type. However, there are some scenarios where it might be best to extend external types, despite this risk. 

So, the `@retroactive` attribute allows you to explicitly declare that you are intentionally adding a conformance that might conflict with future updates to the original module.

## When to Use It
**⚠️ You probably shouldn't use `@retroactive`.**
Consider it a code smell. 

If you **must** use it, then be sure to check every time you update your dependency to a new version. If they have added the conformance themselves, then this will create a conflict. 

If you use `@retroactive`, you are, in fact, explicitly declaring that you acknowledge the risk and are willing to take responsibility for potential future conflicts.

## How to Use It

```swift
extension ExternalType: @retroactive ExternalProtocol {
    // Implementation here
}
```


## Alternative (for pre-Swift 6)

If you need to support older Swift language modes, you can silence the warning by fully qualifying the types:

```swift
extension Module.ExternalType: OtherModule.ExternalProtocol {
    // Implementation here
}
```

## Conclusion
Remember, while `@retroactive` provides a solution, it's best to avoid adding conformances to external types and protocols whenever possible to maintain better compatibility and reduce potential conflicts.


## Recommended Reading
- Read the full Swift Evolution proposal for more [info](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0364-retroactive-conformance-warning.md).
- [Extensions in Swift: How and when to use them - SwiftLee](https://www.avanderlee.com/swift/extensions/) 