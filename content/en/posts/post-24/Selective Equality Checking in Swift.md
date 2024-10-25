---
title: 'Selective Equality Checking in Swift'
slug: selective-equality-checking-in-swift
date: 2024-11-05
series: ["Swift Equatability"]
topics: ["Swift", "Equatable Protocol", "Parameter Packs"]
images: 
description: 
---

## Why Not Just Use Equatable
### The Problem with Automatic Equatable Synthesis
#### It's Only Possible in the Same Source File

#### It Can Be Tough To Guarantee That All Nested Types and Properties Are Equatable
This is especially a problem when your codebase:
1. is still evolving
2. when your codebase depends on outside dependencies which you don't control
3. relies on OOP classes which are unsuited to equatability

### The Problem with Manual Equatable Conformance
Swift also allows you to manually conform a type to Equatable. This is like an "escape hatch". 
However, I recommend avoiding this. Manual Equatable conformance does not automatically update as your code base evolves. This is more code for you to maintain. It is very easy to forget to update. Improper Equatable conformance leads to false positives and false negatives on tests, and subtle hard to find bugs. 

---
## Introducing Easy, Selective Equality Checking
For our examples today we'll be using the simple `Person` type: 

```swift
struct Person {
   let firstName: String
   let lastName: String
   let age: Int
   let id: UUID
   let profileImage: UIImage
}
```

Let's first imagine the kind of code we would like to write and then figure out how we would implement that. It would be nice if the call site could look like this: 

```swift
let person1 = Person(firstName: "Blob", lastName: "McBlob", age: 34, id: UUID())
let person2 = Person(firstName: "Blob", lastName: "McBlob", age: 34, id: UUID())
person1.isEqualTo(person2, by: \.firstName, \.lastName, \.age)
```

The above code reads almost like plain english. 
It's also nice that `Person` is not required to be `Equatable`. 
Let's try to figure out how we could build something like this. 

Our dream requirements are: 
1. A function that could work on practically any type
2. A function that doesn't require the types to be `Equatable`
3. A function that can selectively choose which properties to evaluate, by using key paths. 

## Concrete Method
In my experience it is best to start with a solution that is as simple, static, and non-generic as possible. Start with something easy. Then after you get the easy case working, figure out how to make it more generic and reusable. 

```swift
extension Person {
    func isEqual(to otherPerson: Person, by keyPaths: KeyPath<Person, String>...) -> Bool {
       for kp in keyPaths {
           if self[keyPath: kp] != otherPerson[keyPath: kp] { return false }
       }
       return true
    }
}

// Example 
person1.isEqualTo(person2, by: \.firstName, \.lastName)
```

Let's evaluate our function: 
1. Pro: It can evaluate equality on an arbitrary amount of properties
2. Con: It only works on `Person`, so it would need to be rewritten for each type.
3. Con: Each property must be a `String`

## Generic Global Function
```swift
/// Check if two values have the same equal value for the same property
func value<T, V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPath: KeyPath<T, V>) -> Bool {
    return lhs[keyPath: keyPath] == rhs[keyPath: keyPath]
}

// Example
value(person1, isEqualTo: person2, by: \.firstName)
```

Let's evaluate our function: 
1. Pro: Now we have a function that can work with any type
2. Pro: They type doesn't have to be `Equatable`
3. Con: We can only evaluate one property at a time. We might as well just directly do an equality check on the property. 

## Checking Multiple KeyPaths
```swift
/// Check if two values have the same equal value for multiple properties of the same type
///
/// This function allows you to check for equality on multiple key paths. However, it has the limitation that each key path
/// must point to a value of the same type.
func value<T, V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPaths: [KeyPath<T, V>]) -> Bool {
    return keyPaths.allSatisfy { keyPath in
        return lhs[keyPath: keyPath] == rhs[keyPath: keyPath]
    }
}
```

Let's evaluate our function: 
1. Pro: Now we can check multiple properties at the same time
2. Con: All of the properties must be of the same type

## Checking Heterogenous Types
```swift
/// Check equality of two values by selectively choosing which properties to compare.
///
/// # Example Usage
/// ```swift
/// struct Person {
///    let firstName: String
///    let lastName: String
///    let age: Int
///    let id: UUID
/// }
/// let person1 = Person(firstName: "Blob", lastName: "McBlob", age: 34, id: UUID())
/// let person2 = Person(firstName: "Blob", lastName: "McBlob", age: 34, id: UUID())
/// person1 == person2 // false
/// person1.id == person2.id // false
/// value(person1, isEqualTo: person2, by: \.firstName, \.lastName, \.age) // true
/// ```
func value<T, each V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPath: repeat KeyPath<T, each V>) -> Bool {
    for kp in repeat each keyPath {
        if lhs[keyPath: kp] != rhs[keyPath: kp] { return false }
    }
    return true
}
```

Let's evaluate our function: 
1. Pro: Now we can check multiple properties at the same time **even when they are different types**!

### Room For Improvement
Our final function doesn't quite match up to our original API design. Remember we wanted to build something that could be used like this: 

```swift
person1.isEqualTo(person2, by: \.firstName, \.lastName, \.age)
```

This is slightly easier to read. However, I couldn't figure out how to implement this. 
This would be an instance method. But we want to add it as a method to almost any type in Swift. There are a few ways that I thought we could achieve it but they all turned out to be dead ends. 

```swift 
// 🔴 Non-nominal type 'Any' cannot be extended
extension Any {
    func value<T, each V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPath: repeat KeyPath<T, each V>) -> Bool {
        // ...
    }
}

// 🔴 Cannot extend protocol 'Copyable'
extension Copyable {
    func value<T, each V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPath: repeat KeyPath<T, each V>) -> Bool {
        // ...
    }
}
```

`Any` (capital A), is a special type in Swift used to represent any possible type in the Swift language. `Copyable` is a type that almost every type in Swift is automatically conformed to unless they explicitly opt out by conforming to `~Copyable`. 

Both of these might be decent categories for adding an instance method, but alas both are not allowed to be extended. And that is probably for the best `Any` and `~Copyable` are two **very** fundamental types in Swift, so there is likely a very good reason why the Swift core team decided to not allow extending them. After all it can be [problematic to extend types that you don't own]({{< ref "post-16">}}).

## Recommended Reading
- [Swift.org | Iterate Over Parameter Packs in Swift 6.0](https://www.swift.org/blog/pack-iteration/)