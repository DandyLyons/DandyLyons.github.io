---
title: 'Unordered Equality Checking in Swift'
slug: 
date: 2024-10-29
series: ["Swift Equatability"]
topics: ["Swift", "Equatable Protocol"]
images: 
description: 
---

`Equatable` is a core feature of Swift. 

## What is Deep Equality

## Swift Equality is Deep By Default

## Sometimes We Don't Need True Deep Equality

## Unordered Equality Checking

Our requirements: 
1. Equality: Accurately checks if two values are equal
2. Deep equality: all of their properties are equal, no matter how deeply nested
3. Unordered: the two values should still be considered "equal" even if they are in different orders
4. Frequency: the values should have the same frequency of elements
5. Instance Method: We want this function to be an instance method. 
6. Easily reusable: We would like this method to be usable from many types without having to rewrite it. 

### Our Dream Call Site
I find it is often helpful to start with what you would like the call site to look like. Then figure out how you would implement that. 

```swift
let array1 = [1, 2, 3, 3]
let array2 = [3, 3, 2, 1]
array1.hasSameElements(as: array2) // true
```

Our function should evaluate to true if and only if: 
1. The same elements are present in both collections.
2. No element is present in one collection but not the other. 
3. Each collection has the same amount of occurences of each element. 
4. The function should still be true if each collection is in a different order.

## Concrete Method on Array
Let's start with adding a concrete method on `Array`. Later we can figure out how to generalize our solution to other types such as `Set`

```swift
extension Array {
    public func hasSameElements(as otherArray: Self) -> Bool {
// ???
    }
}
```

We have a clear function definition. Now we need to figure out how to implement this. Remember we can't simply use `self == otherArray` because it would check both equality AND ordering. In other words we need to figure out how to count the frequency of each element in the array. 

### Implementing `countFrequency()`

```swift
extension Array where Element: Hashable {
    public func countFrequency() -> [Element: Int] {
        var result = [Element: Int]()
        for element in self {
            result[element, default: 0] += 1
        }
        return result
    }
}
```

#### Hashable Requirement
Try removing `where Element: Hashable`. You'll see that our method will fail to compile. This is because we are using a `Dictionary` and `Dictionary` requires that all of its keys conform to `Hashable`. 

### Implementing `hasSameElements(as:)`

Now that we have `countsFrequency()` we can finish implementing `hasSameElements(as:)`. 

```swift
extension Array where Element: Hashable {
    public func hasSameElements(as otherArray: Self) -> Bool {
        let freq1 = self.countFrequency()
        let freq2 = otherArray.countFrequency()
        return freq1 == freq2
    }
}
```

## Generalizing Our Solution
Now that we figured out how to add this method to `Array`. What we want to do is add this method to any type that might be able to benefit from this functionality. In OOP languages we would do this by adding it as a method on a superclass. Then every subclass would automatically inherit the new method. This is a fine strategy, but Swift offers another approach: protocol inheritance. 

Protocols offer a few benefits. A type can inherit multiple protocols, unlike classes. Also, value types like `structs` and `enums` can also conform to and inherit protocols. So let's not fight against the language. Let's work with the strategy that is used throughout the standard library and ecosystem. Let's add our method to a protocol. 

The problem is... which protocol should we extend? Answering this question is a regular painpoint for me. Swift protocols are wonderful because they are simple, self-contained, and very composable. Unfortunately that also means that they have a very very complex web of inheritance hierarchies. 

After much head scratching, I eventually settled on this: 

```swift
extension Sequence where Element: Hashable {
    /// count the amount of unique occurences of each value in a type
    public func countFrequency() -> [Element: Int] {
        var result = [Element: Int]()
        for element in self {
            result[element, default: 0] += 1
        }
        return result
    }
}

extension Sequence where Element: Hashable {
    /// Check for collection equality while ignoring order
    public func hasSameElements(as c2: Self) -> Bool {
        let freq1 = self.countFrequency()
        let freq2 = c2.countFrequency()
        return freq1 == freq2
    }
}
```

I chose `Sequence` because it is the most fundamental protocol for our use case. It doesn't inherit from any other protocol. Practically all of the types that hold multiple values inherit from `Sequence`. For example `Array`, `Set`, `Dictionary`, `Range` etc. 

### Optimization
This function meets our requirements nicely. It's easy to read, and it is reusable in so many types and situations. However, perhaps we could improve it's performance a little. Currently we must iterate through both sequences entirely. That's two `O(n)` iterations back to back.

But what if they have different counts? Then we already know that the answer should be `false`. All of that work is unnecessary. Why don't we read the `count`, and escape early if the `count` is unequal? Now add this:

```swift
extension Collection where Element: Hashable {
    /// Check for collection equality while ignoring order
    public func hasSameElements(as c2: Self) -> Bool {
        guard self.count == c2.count else { return false }
        let freq1 = self.countFrequency()
        let freq2 = c2.countFrequency()
        return freq1 == freq2
    }
}
```

`Sequence` has no `count` property, but `Collection` does. Now we have two implementations of the same method. Remember `Collection` inherits from `Sequence`. This means that if a `Collection` type calls this method it will use the `Collection` implementation, NOT the `Sequence` implementation. And that's great because the `Collection` implementation is more efficient!

## Conclusion

## Recommended Reading
- [Swift by Sundell | The different categories of Swift protocols](https://www.swiftbysundell.com/articles/different-categories-of-swift-protocols)
- [Swift forums | Is there any easy way to see the entire protocol hierarchy of ...](https://forums.swift.org/t/is-there-any-easy-way-to-see-the-entire-protocol-hierarchy-of-something-like-array-or-double/49193)
- [Swiftdoc.org | Sequence hierarchy graph (outdated Swift 4.2)](https://swiftdoc.org/v4.2/protocol/sequence/hierarchy/): (Unfortunately this is the latest I could find.)
