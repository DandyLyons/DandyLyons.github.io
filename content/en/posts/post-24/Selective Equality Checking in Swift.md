---
title: 'Selective Equality Checking in Swift'
slug: selective-equality-checking-in-swift
date: 2024-11-05
series: ["Swift Equatability"]
topics: ["Swift", "Equatable Protocol", "Parameter Packs"]
images: 
description: Learn how to check equality in Swift WITHOUT using Equatable? Now you can pick and choose which properties you would like to check equality on. 
---

The humble `Equatable` protocols is one of the most fundamental tools in Swift, but sometimes it is not always the best tool for the job. Last week we learned how to [check equality for collections while ignoring order]({{<ref "Unordered Equality Checking in Swift">}}). Today we will learn how to pick and choose exactly what properties we would like to check equality on. But first let's talk about the problem: 

## Why Not Just Use Equatable
For the majority of use cases the best option is to just use the plain old `==` operator. We get this operator automatically when a type conforms to `Equatable`. However it's not always easy conform to `Equatable`. Here are some situations when it might not be feasible or even possible to conform to `Equatable`. 

### The Problem with Automatic Equatable Conformance
For the majority of cases, we should start with trying to use automatic `Equatable` conformance. Let the compiler let that boilerplate code for you. This is trivially easy to do in most cases, especially for value types. Simply add `: Equatable` to your type declaration. 

```swift
struct MyStruct: Equatable {
    let int: Int
}
```

Simple. Swift did all the hard work for us. We even have the option of applying `Equatable` in an extension. This becomes especially handy for generic types. 

```swift
struct MyType<Value> {
    var value: Value
}

extension MyType: Equatable where Value: Equatable {}
// conforms automatically
```

Under normal circumstances Swift would not be able to conform `MyType` to `Equatable` automatically because it holds onto a generic `Value` type. Since we don't know in advance if `Value` is `Equatable`, the compiler is unable to automatically generate a conformance. But when we apply `where Value: Equatable` then the compiler has all the info it needs to create the conformance. When `Value` is `Equatable`, so is `MyType`. but when `Value` is NOT `Equatable`, neither is `MyType`. 

Unfortunately, this automatic conformance is not always available.

#### The Conformance Must Be Done In The Same File As The Type Declaration
You can apply `Equatable` at the type declaration or in an `extension` but there is a catch. If you use an `extension` it must be in the same file as the type declaration. Otherwise the compiler will refuse to automatically synthesize a conformance.

#### It Can Be Tough To Guarantee That All Nested Types and Properties Are Equatable
This is especially a problem when your codebase:
1. is still evolving
2. when your codebase depends on outside dependencies which you don't control
3. relies on OOP classes which are unsuited to equatability

If your code is still evolving then maybe it's a great fit for `Equatable` now. But later? Maybe not so much. 

##### The Problem With `Equatable` For Reference Types
For reasons that are beyond the scope of this article, it can be quite problematic to do equality checking for reference types such as classes and actors. The short explanation is that reference types encapsulate identity AND behavior. Multiple places could hold on to the same reference and edit the value out from under you. `Equatable` just doesn't quite make sense for many/most reference types. 

In most cases, I recommend avoiding conforming a class to `Equatable`. If you must conform a class to equatable, I recommend simply checking if they are the same instance using the `===` operator and calling it a day. 

```swift
extension MyClass: Equatable {
    static func == (lhs: MyClass, rhs: MyClass) -> Bool {
        return lhs === rhs
    }
}
```

### The Problem with Manual Equatable Conformance
Swift also allows you to manually conform a type to `Equatable`. This is like an "escape hatch". However, I recommend avoiding this. Manual Equatable conformance does not automatically update as your code base evolves. This is more code for you to maintain. It is very easy to forget to update. Improper `Equatable` conformance leads to false positives and false negatives on tests, and subtle hard to find bugs. 

#### When Using A Type That You Don't Control
If you attempt to add an `Equatable` conformance to a library from an outside library when using Swift 6 language mode you will see a warning from the compiler. We can silence this warning using `@retroactive`. But first, [you should read this article on why that's probably a bad idea]({{<ref "post-16">}}). 

---

Alright, we've sufficiently delivered the bad news. Those are the many situations where `Equatable` isn't quite up to the task. Now, what can we do about it? How can we check equality, when `Equatable` isn't readily available? 

## Introducing Easy, Selective Equality Checking
For our examples today we'll be using the simple `Person` type: 

```swift
struct Person: Identifiable {
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

### Our Requirements
Let's try to figure out how we could build something like this. 

Our dream requirements are: 
1. A function that could work on practically any type.
2. A function that doesn't require the types to be `Equatable`.
3. A function that can selectively choose which properties to evaluate, by using key paths.

### Why `Equatable` Doesn't Quite Work For `Person`
But first let's understand why we would need to build this in the first place. Why not just use `Equatable`. Well, our `Person` struct has a few problems that make it not the perfect candidate for `Equatable` conformance:

The `id` property is a `UUID`. `UUID` conforms to `Equatable` so it's easy enough to conform automatically. But what if we need to check for duplicate persons? What if we need to check if we accidentally created a new `Person` with a new `UUID`? We'd have to fall back to ad hoc equality checking of the other properties anyway. 

Next, our `Person` type also holds onto a `UIImage`, which is a reference type, and is not `Equatable`. So our `Person` type can't automatically synthesize `Equatable` conformance. We could manually conform it, but then we'd have to maintain it. It's easy to forget to update this conformance as the type evolves, and thus it's easy to introduce subtle bugs. 


## Concrete Method
In my experience it is best to **start with a solution that is as simple, static, and non-generic as possible**. Start with something easy. Then after you get the easy case working, **figure out how to make it more generic and reusable**. So let's implement our API just for the `Person` type first:

```swift
extension Person {
    func isEqual(to otherPerson: Person, by keyPaths: KeyPath<Person, String>...) -> Bool {
       for kp in keyPaths {
           if self[keyPath: kp] != otherPerson[keyPath: kp] { return false }
       }
       return true
    }
}

// Example Usage
person1.isEqualTo(person2, by: \.firstName, \.lastName)
```

Let's evaluate our function: 
1. **Pro**: It can evaluate equality on an arbitrary amount of properties.
2. **Pro**: `Person` isn't required to be `Equatable`.
3. **Con**: It only works on `Person`, so it would need to be rewritten for each type.
4. **Con**: Each property must be a `String`. 

>**What's that `...` syntax?**
>Pay attention to the `...` operator. This tells the compiler that `keyPaths` is a [variadic parameter](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions/#Variadic-Parameters). This means that there can be as many or few `keyPaths` as we want. We don't know ahead of time how many it will be. Under the hood it behaves just like an `Array`. 

## Generic Global Function
Now that we've figured out how to meet at least some of our requirements with the `Person` type, let's figure out how to generalize our solution to something that can work with other types:

```swift
/// Check if two values have the same equal value for the same property
func value<T, V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPath: KeyPath<T, V>) -> Bool {
    return lhs[keyPath: keyPath] == rhs[keyPath: keyPath]
}

// Example Usage
value(person1, isEqualTo: person2, by: \.firstName)
```

Let's evaluate our function: 
1. **Pro**: Now we have a function that can work with any type.
2. **Pro**: They type isn't required to be `Equatable`.
3. **Con**: We can only evaluate one property at a time. We might as well just directly do an equality check on the property. 

## Checking Multiple KeyPaths (Of The Same Type)
Okay so now that we've generalized our function, let's try to accept multiple key paths at the same time:

```swift
/// Check if two values have the same equal value for multiple properties of the same type
///
/// This function allows you to check for equality on multiple key paths. However, it has the limitation that each key path
/// must point to a value of the same type.
func value<T, V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPaths: KeyPath<T, V>...) -> Bool {
    return keyPaths.allSatisfy { keyPath in
        return lhs[keyPath: keyPath] == rhs[keyPath: keyPath]
    }
}

// Example Usage
value(person1, isEqualTo: person2, by: \.firstName, \.lastName)
value(person1, isEqualTo: person2, by: \.age) // age must be checked separately because it's a different type. 
```

Let's evaluate our function: 
1. **Pro**: Now we can check multiple properties of the same time
2. **Pro**: Now we have a function that can work with any type.
3. **Pro**: They type isn't required to be `Equatable`.
4. **Con**: All of the properties must be of the same type

## Checking Heterogenous Types
Now let's try to accept a collection of `KeyPath`s that can point to any type: 

```swift
func value<T, each V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPath: repeat KeyPath<T, each V>) -> Bool {
    for kp in repeat each keyPath {
        if lhs[keyPath: kp] != rhs[keyPath: kp] { return false }
    }
    return true
}

// example usage
value(person1, isEqualTo: person2, by: \.firstName, \.lastName, \.age)
```

### How It Works
This solution uses a new Swift 6.0 feature called [Parameter Pack Iteration](https://www.swift.org/blog/pack-iteration/). First we declare that the function receives many types `V`, all of which conform to `Equatable`. Then we accept a pack of `KeyPath` values (notice the `repeat`). Each of these key paths goes from type `T` to `each V`, and each V type will be `Equatable`. Then we iterate through each keypath, and compare the values to each other. 

>**Note**: For some reason, this feature appears to work for me even when I am using Swift 5 language mode. So even though the blog says that it is a Swift 6 feature, it appears to not require the Swift 6 language mode. Make sure you read my post? "[Am I Using Swift 5 or 6?]({{< ref "Am I Using Swift 5 or 6" >}})" to understand the difference between Swift 6, **the tools** and Swift 6, **the language mode**. 

Now, let's evaluate our function again: 
1. Pro: Now we can check multiple properties at the same time **even when they are different types**! 

### Room For Improvement
Our final function doesn't quite match up to our original API design. Remember we wanted to build something that could be used like this: 

```swift
person1.isEqualTo(person2, by: \.firstName, \.lastName, \.age)
```

This is slightly easier to read. However, I couldn't figure out how to implement this. 
This would be an instance method. But we want to add it as a method to almost any type in Swift. There are a few ways that I thought we could achieve it but they all turned out to be dead ends. 

## Selective Equality Checking
```swift
struct Person: Identifiable {
   let firstName: String
   let lastName: String
   let age: Int
   let id: UUID
   let profileImage: UIImage
}
value(person1, isEqualTo: person2, by: \.firstName, \.lastName, \.age)
```

### Works Great With Reference Types
As we noted before, `Equatable` doesn't quite work for reference types. But our `value(isEqualTo:by:)` function works great with reference types! Look what happens if we change `Person` to a class: 

```swift
class Person: Identifiable {
   let firstName: String
   let lastName: String
   let age: Int
   let id: UUID
   let profileImage: UIImage
}
value(person1, isEqualTo: person2, by: \.firstName, \.lastName, \.age)
```

Here the code works exactly the same. The call site makes it very clear that we are not checking if two `Person` instances are the same instance. Instead we are checking if they have the same values for the same properties.

>**Note:** Don't forget that if we want to check if two class instances are the same instance, we can use the `===` operator like this: 

```swift
person1 === person2
```


## Conclusion
Well there you have it, **Selective Equality Checking in Swift**. We can now easily and ergonomically check for equality on select properties and we don't need to conform our types to `Equatable`. Do you like this solution? Good news! I now have an even better solution that is even easier to use. It's a micro-library called [SelectiveEquatable](https://dandylyons.net/posts/post-27/selectiveequatable/). 


---

## Recommended Reading
- [Swift.org | Iterate Over Parameter Packs in Swift 6.0](https://www.swift.org/blog/pack-iteration/)
- Parameter Packs (5.9)
  - [swift-evolution/proposals/0393-parameter-packs.md at main · swiftlang/swift-evolution](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0393-parameter-packs.md)
  - [Value and Type parameter packs in Swift explained with examples](https://www.avanderlee.com/swift/value-and-type-parameter-packs/) 