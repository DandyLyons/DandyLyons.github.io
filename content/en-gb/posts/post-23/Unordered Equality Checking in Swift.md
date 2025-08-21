---
title: Unordered Equality Checking in Swift
slug: unordered-equality-checking-in-swift
date: 2024-10-29
series:
  - Swift Equatability
topics:
  - Swift
  - Equatable Protocol
images:
description: Learn how to ignore ordering when checking equality in Swift.
tags:
  - Swift
---

Have you ever needed to compare two arrays in Swift, but the order of elements doesn't matter? I find this often happens to me when convert between an ordered type such as `Array` and an unordered type such as `Set` or `Dictionary`.  Today, we'll explore how to implement **unordered equality checking** in Swift, starting with the basics and working our way up to a flexible, protocol-based solution.

## What is Deep Equality?

Before diving into unordered equality, let's briefly discuss deep equality. Many programming languages struggle with deep equality comparisons. Take JavaScript, for example:

```javascript
const a1 = 1
const a2 = 1
console.log(a1 === a2)  // true

const obj1 = { a: 1, b: { c: 2 } }
const obj2 = { a: 1, b: { c: 2 } }

console.log(obj1 === obj2)  // false
console.log(obj1.b === obj2.b)  // false
console.log(obj1.b.c === obj2.b.c)  // true
```
In this example, we have two reference types `obj1` and `obj2`. They have the exact same structure so from a value perspective we could say that they are "equal". 

JavaScript's `===` operator only checks reference equality for objects, **not their contents**. In other words, JavaScript does not check for **deep equality**. If you'd like to check for deep equality, you'd need to manually implement it yourself or use a library like Lodash's `_.isEqual()`.

## Swift Equality is Deep By Default

Swift, on the other hand, provides deep equality out of the box through the `Equatable` protocol. When you compare two values using `==`, Swift automatically performs a deep comparison of all their properties:

```swift
struct Person: Equatable {
    let name: String
    let age: Int
    let address: Address
}

struct Address: Equatable {
    let street: String
    let city: String
}

let person1 = Person(name: "John", age: 30, address: Address(street: "123 Main St", city: "Boston"))
let person2 = Person(name: "John", age: 30, address: Address(street: "123 Main St", city: "Boston"))

print(person1 == person2)  // true
```
Of course, that is assuming that each type and all their nested types correctly implemented `Equatable`. If you have any custom types with an incorrect implementation of `Equatable` then that incorrect implementation will bubble up to every type that holds it as a property. Thankfully, for value types, Swift implements `Equatable` automatically for us, so we get automatically correct deep equality checking for most types!  

## Sometimes We Don't Want True Deep Equality

While deep equality is great, sometimes we need something different. Consider a scenario where you're working with collections and you care about *what* elements are present, but not *where* they appear. For example:

- Checking if two arrays contain the same elements regardless of order
- Verifying that two sets of user permissions are equivalent
- Comparing two API responses to see if there has been any change. 

## Unordered Equality Checking

Let's implement a solution that satisfies these requirements:

1. **Equality**: Accurately checks if two values are equal
2. **Deep equality**: all of their properties are equal, no matter how deeply nested
3. **Unordered**: the two values should still be considered "equal" even if they are in different orders
4. **Frequency**: the values should have the same frequency of elements (for example, if `array1` has three `"A"` strings, then so should `array2`)
5. **Instance Method**: We want this function to be an instance method, usable directly from the collection type.
6. **Easily reusable**: We would like this method to be **usable from many types** without having to rewrite it

### Our Dream Call Site

Let's start with what we want our API to look like:

```swift
let array1 = [1, 2, 3, 3]
let array2 = [3, 3, 2, 1]
array1.hasSameElements(as: array2)  // true
```

This should return `true` if and only if:
1. The same elements are present in both collections
2. No element is present in one collection but not the other
3. Each collection has the same number of occurrences of each element
4. The function should still return true if each collection is in a different order

## Concrete Method on Array

A good principle is don't start with generics. Instead, start with a concrete type, then generalize your code AFTER you get the concrete version working. Remember we can't simply use `self == otherArray` because it would check both equality AND ordering. In other words we need to figure out how to count the frequency of each element in the array. Let's start by implementing this functionality specifically for arrays:

```swift
extension Array where Element: Hashable {
    public func countFrequency() -> [Element: Int] {
        var result = [Element: Int]()
        for element in self {
            result[element, default: 0] += 1
        }
        return result
    }
    
    public func hasSameElements(as otherArray: Self) -> Bool {
        let freq1 = self.countFrequency()
        let freq2 = otherArray.countFrequency()
        return freq1 == freq2
    }
}
```

First we will count the number of occurances of each unique value in the `Array` with our new `countFrequency` method. Here we simply create a `Dictionary` and store each element in the dictionary. Every time we find a new value we will increment up the count by one. Now that we've implemented counting the frequency, we can simply compare the frequency of both arrays using another new method: `hasSameElements(as:)`. 

### The Hashable Requirement

Notice the `where Element: Hashable` constraint. This is crucial because we're using a `Dictionary` to count frequencies, and dictionary keys must be `Hashable`. If you remove this constraint, the code won't compile. This is an unfortunate extra contraint but it's more than a fair tradeoff in this case. The `Hashable` protocol in Swift inherits from `Equatable`, meaning every `Hashable` type is `Equatable` and most `Equatable` types are `Hashable`. Most types can let the compiler automatically synthesize `Hashable` conformance for them. 

## Generalizing Our Solution

Now that we figured out how to add this method to `Array`. What we want to do is add this method to any type that might be able to benefit from this functionality. In OOP languages we would do this by adding it as a method on a superclass. Then every subclass would automatically inherit the new method. This is a fine strategy, but Swift offers another approach: protocol inheritance. 

Protocols offer a few benefits. A type can inherit multiple protocols, unlike classes. Also, value types like `structs` and `enums` can also conform to and inherit protocols. So let's not fight against the language. Let's work with the strategy that is used throughout the standard library and ecosystem. Let's add our method to a protocol. 

The problem is... which protocol should we extend? Answering this question is a regular painpoint for me. Swift protocols are wonderful because they are simple, self-contained, and very composable. Unfortunately that also means that they have a [very very complex web of inheritance hierarchies](https://swiftdoc.org/v4.2/protocol/sequence/hierarchy/). 

After much head scratching, I eventually settled on this:

```swift
extension Sequence where Element: Hashable {
    /// Count the number of occurrences of each value in a sequence
    public func countFrequency() -> [Element: Int] {
        var result = [Element: Int]()
        for element in self {
            result[element, default: 0] += 1
        }
        return result
    }
    
    /// Check for sequence equality while ignoring order
    public func hasSameElements(as s2: Self) -> Bool {
        let freq1 = self.countFrequency()
        let freq2 = s2.countFrequency()
        return freq1 == freq2
    }
}
```

I chose `Sequence` because it is the most fundamental protocol for our use case. It doesn't inherit from any other protocol. Practically all of the types that hold multiple values inherit from `Sequence`. For example `Array`, `Set`, `Dictionary`, `Range` etc.

### Performance Optimization

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

## Real-World Usage

Here are some practical examples of where you might use this functionality:

```swift
// Comparing arrays of numbers
let numbers1 = [1, 2, 3, 3]
let numbers2 = [3, 1, 3, 2]
print(numbers1.hasSameElements(as: numbers2))  // true

// Comparing sets of strings
let set1: Set = ["apple", "banana", "orange"]
let set2: Set = ["orange", "apple", "banana"]
print(set1.hasSameElements(as: set2))  // true

// Working with custom types
struct User: Hashable {
    let id: Int
    let name: String
}

let users1 = [User(id: 1, name: "Alice"), User(id: 2, name: "Bob")]
let users2 = [User(id: 2, name: "Bob"), User(id: 1, name: "Alice")]
print(users1.hasSameElements(as: users2))  // true
```

## Conclusion

By leveraging Swift's protocol-oriented programming and type system, we've created a flexible, reusable solution for unordered equality checking. Our implementation:

- Works with any `Sequence` whose elements are `Hashable`
- Provides optimized performance for `Collection` types
- Maintains type safety through protocol constraints
- Is easy to use and understand

This approach demonstrates the power of Swift's protocol system and shows how we can create elegant, reusable solutions to common programming challenges. If you like this approach, then grab the code for yourself [here](https://gist.github.com/DandyLyons/8ab7e104c25a9ed3d3a58967de1fb037). 

Next week we'll continue our series on equatability in Swift, learning how to selectively check equality on just the properties we care about.

## Recommended Reading
- [Swift by Sundell | The different categories of Swift protocols](https://www.swiftbysundell.com/articles/different-categories-of-swift-protocols)
- [Swift forums | Is there any easy way to see the entire protocol hierarchy of ...](https://forums.swift.org/t/is-there-any-easy-way-to-see-the-entire-protocol-hierarchy-of-something-like-array-or-double/49193)
- [Swiftdoc.org | Sequence hierarchy graph (outdated Swift 4.2)](https://swiftdoc.org/v4.2/protocol/sequence/hierarchy/): (Unfortunately this is the latest I could find. Please let me know if you find something more up to date.)