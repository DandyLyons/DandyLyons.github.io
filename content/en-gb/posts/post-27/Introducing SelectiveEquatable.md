---
title: 'Introducing SelectiveEquatable'
slug: selectiveequatable
date: 2024-12-12
series: ["Swift Equatability"]
topics: ["Swift", "Equatable Protocol", "SelectiveEquatable"]
images: ["SelectiveEquatable.png"]
description: Quickly and easily check for equality on specific properties in Swift with the new SelectiveEquatable protocol.
---

A few weeks ago, I released a blog post named ["Selective Equality Checking in Swift"](https://dandylyons.net/posts/post-24/selective-equality-checking-in-swift/). In that post, I designed and implemented an API to check for equality on specific properties of a type. Today, I am excited to announce a new Swift protocol named `SelectiveEquatable`, that makes all of this even easier. Let's see it in action.

## Using SelectiveEquatable
To use the `SelectiveEquatable` protocol, all you need to do is add a conformance to it like this: 

```swift
extension MySwiftType: SelectiveEquatable {}
```

And that's it! Now you get a new method which allows you to check for equality on specific properties of your type. 

```swift
let instance1 = MySwiftType(int: 1, string: "Hello", bool: true)
let instance2 = MySwiftType(int: 1, string: "World", bool: true)
print(instance1 == instance2) // false
print(instance1.isEqual(to: instance2, by: \.int, \.bool)) // true
```

Here we simply use the new `isEqual(to:by:)` method. We supply it a keypath to the properties we want to check for equality on. In this case, we are checking for equality on the `int` and `bool` properties. The `by` parameter will accept as many keypaths as you want, and for any type, as long as the type conforms to `Equatable`.

## Installing SelectiveEquatable
There are two main ways to install `SelectiveEquatable` in your project. The first is to simply copy and paste the protocol into your project. You can find the entire code right [here](https://github.com/DandyLyons/SelectiveEquatable/blob/main/Sources/SelectiveEquatable/SelectiveEquatable.swift).

The second is to use the Swift Package Manager. If you already have a library that other code depends on, then it might be easier/more convenient to add the "SelectiveEquatable" package as a dependency to your project or package. The best place to find the package is on [Swift Package Index](https://swiftpackageindex.com/DandyLyons/SelectiveEquatable)! 

## Conclusion
I hope you find the `SelectiveEquatable` protocol useful in your projects. It is a simple and easy way to check for equality on specific properties of a type. Please star it on [GitHub](https://github.com/DandyLyons/SelectiveEquatable) if you like it, and feel free to open an issue or pull request if you have any suggestions or improvements.