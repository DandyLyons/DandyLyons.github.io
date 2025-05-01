---
title: Easy Deep Copy Cloning in Swift
description: How to force value semantics in Swift by using the Cloneable protocol.
date: 2025-02-04
tags: ["Swift", "Value Semantics", "Reference Types", "Cloning", "Codable", "Value Types"]
slug: easy-deep-copy-cloning-in-swift
---

In most programming languages, there is some concept of value and reference types. In Swift, we prefer to use value types and value semantics whenever possible. This is because value types are easier to reason about since they cannot be mutated by other parts of the code.[^1] However there are some times when we must use reference types. Is there a way to get our reference types to behave like value types? Yes, there is.

[^1]: To be clear, value types are not better or worse than reference types. They both have very valid use cases.

## Value Semantics vs. Reference Semantics
Remember that value semantics means that when you copy a value, you get a **new copy of the value**. This is in contrast to reference semantics where when you copy a reference, you get a **new reference to the same object**.

```swift
struct ValueType {
    var int: Int
}
class ReferenceType {
    var int: Int
    init(int: Int) {
        self.int = int
    }
}
var value1 = ValueType(value: 1)
var value2 = value1
value2.int = 2
print(value1.int) // 1
print(value2.int) // 2

var reference1 = ReferenceType(value: 1)
var reference2 = reference1
reference2.int = 2
print(reference1.int) // 2
print(reference2.int) // 2
```

As you can see, when we copy a value type, we get a new copy of the value. When we copy a reference type, we get a new reference to the same object. Therefore, if we change the value of the reference type, it will change the value of the original reference type as well. But if we change the value of the value type, only that value will change. 

But **one of the cool things about reference types is that we can force them to behave like value types**, by copying their values instead of their reference. When a reference type **behaves like a value type** we call this _value semantics_. Swift regularly does this through a strategy called _copy-on-write_[^2], but let's look at another way to accomplish this.

[^2]: For example, Swift uses copy-on-write for `Array`, `String`, and `Dictionary`. In practice, these types *behave* like value types because they are copy-on-write, but under the hood, they are actually reference types.

## Cloning A Reference Type
Another way to force a reference type to behave like a value type is to clone it. Notice I said _clone_ and not _copy_. When you clone a reference type, you are creating a new instance of the reference type that just happens to have the same values as the original instance. This way, you can change the values of the cloned reference instance without affecting the original reference instance. 

```swift
var reference1 = ReferenceType(int: 1)
var reference2 = ReferenceType(int: reference1.int)
reference2.int = 2
print(reference1.int) // 1
print(reference2.int) // 2
```

Here we created an entirely new instance of `ReferenceType` and copied the value of `reference1` into `reference2`. Now, when we change the value of `reference2`, it will not affect `reference1`. This strategy is useful but can be quite cumbersome if we have many values. Let's enforce this behavior through a new protocol named `Cloneable`.

```swift
protocol Cloneable {
    init(cloning original: Self)
    func clone() -> Self
}
extension Cloneable {
    func clone() -> Self {
        return Self(cloning: self)
    }
}
var reference = ReferenceType(int: 1)
var referenceCopy = reference
var referenceClone = reference.clone()
reference.int = 2
print(reference.int) // 2
print(referenceCopy.int) // 2
print(referenceClone.int) // 1
```

Now, we can enforce value semantics on our reference type by making it conform to the `Cloneable` protocol. This way, we can guarantee that when we clone the reference type, we get a new instance of it with the same values.

```swift
extension ReferenceType: Cloneable {
    required init(cloning original: ReferenceType) {
        self.int = original.int
    }
}
```

And what's extra nice is that the `clone()` method is now generated for us automatically.
    
```swift
var reference = ReferenceType(int: 1)
var referenceClone = reference.clone()
```

Unfortunately this is a little extra work to maintain. If our `ReferenceType` ever changes we must remember to update the `Cloneable` protocol implementation as well. Thankfully, the compiler has our back and should warn us in most cases. If we rename, or add or remove a property, the compiler will show an error that the initializer is not valid. 👍🏼

## Deep Copy vs. Shallow Copy
It is important to note that the problem is a little more complex than it seems. When we clone a reference type, we can either do a _deep copy_ or a _shallow copy_. A _shallow copy_ only copies the top-level properties of the reference type. A _deep copy_ copies all the properties of the reference type, including any reference types it contains. In order to do a true clone, we must do a _deep copy_. If we merely had a shallow copy, we would still be pointing to references from the original instance, which would still lead to surprising side effects. For example, let's say we added a `ReferenceType` property to our `ReferenceType`:

```swift
class ReferenceType: Cloneable {
    var int: Int
    var anotherReference: AnotherReferenceType
    init(int: Int, otherRef: AnotherReferenceType) {
        self.int = int
        self.anotherReference = otherRef
    }

    required init(cloning original: ReferenceType) {
        self.int = original.int
        self.anotherReference = original.anotherReference
    }
}
class AnotherReferenceType {
    var string: String
    init(string: String) {
        self.string = string
    }
}
var reference = ReferenceType(int: 1, otherRef: AnotherReferenceType(string: "Hello"))
var referenceClone = reference.clone()
reference.anotherReference.string = "Goodbye"
print(reference.anotherReference.string) // Goodbye
print(referenceClone.anotherReference.string) // Goodbye
```

Why did this happen? Because the implementation of `Cloneable` was incorrect. It only did a shallow copy. We copied every property on `ReferenceType`. The `int` property is a value type, so when we copied it we created an entirely new instance of the `Int`. But the `anotherReference` property is a reference type. When we copied it, we only copied the reference to the `AnotherReferenceType` instance. We didn't create a new instance of `AnotherReferenceType`. So when we changed the `string` property of `anotherReference` on the `reference` instance, it also changed on the `referenceClone` instance. In other words, we didn't do a deep copy. We only did a shallow copy. Let's correct this:

```swift
class ReferenceType: Cloneable {
    var int: Int
    var anotherReference: AnotherReferenceType
    required init(cloning original: ReferenceType) {
        self.int = original.int
        self.anotherReference = original.anotherReference.clone()
    }
    // ...
}
class AnotherReferenceType: Cloneable {
    var string: String
    required init(cloning original: AnotherReferenceType) {
        self.string = original.string
    }
    // ...
}
```

Now, when we clone the `ReferenceType`, we also clone the `AnotherReferenceType` instance. This way, when we change the `string` property of `anotherReference` on the `reference` instance, it will not change on the `referenceClone` instance. 

```swift
var reference = ReferenceType(int: 1, otherRef: AnotherReferenceType(string: "Hello"))
var referenceClone = reference.clone()
reference.anotherReference.string = "Goodbye"
print(reference.anotherReference.string) // Goodbye
print(referenceClone.anotherReference.string) // Hello
```

## Deep Copy Clones For Free Using Codable
By now, you should realize that deep copying can be quite complex. We must remember to clone every property of the reference type, including any reference types it contains, and any reference types they contain, and so on. This can be quite cumbersome and error prone. But there is a way to get deep copy clones for free! If our reference type is `Codable`, we can get deep copy clones for free. This is because when an instance is encoded and decoded, an entirely new instance is created. 

```swift
extension Cloneable where Self: Codable {
    func cloneUsingCodable() -> Self? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: data)
    }
}
extension ReferenceType: Codable {}
extension AnotherReferenceType: Codable {}
```

Remember that when every property of a type is `Codable`, then Swift can automatically synthesize the `Codable` conformance for that type. This is why we don't need to implement the `Codable` protocol for `ReferenceType` and `AnotherReferenceType`. Now that both `ReferenceType` and `AnotherReferenceType` are `Codable`, we can get deep copy clones for free using the `cloneUsingCodable()` method. 

But there is a slight catch. As you can see, `cloneUsingCodable()` returns an Optional. This is because encoding and decoding can fail. So we must first unwrap the optional before using the cloned instance.

>In all likelihood, it is probably completely safe to force unwrap the optional. This is because the value was already a valid instance of the type or else you wouldn't be able to call `cloneUsingCodable()`. So as long as your `Encodable` and `Decodable` implementations are correct, you should be fine. And if those implementations were auto-synthesized by Swift, then you should be very confident that they are correct.

```swift
let reference = ReferenceType(int: 1, otherRef: AnotherReferenceType(string: "Hello"))
if let referenceClone = reference.cloneUsingCodable() {
    reference.anotherReference.string = "Goodbye"
    print(reference.anotherReference.string) // Goodbye
    print(referenceClone.anotherReference.string) // Hello
}
```

Now, when we change the `string` property of `anotherReference` on the `reference` instance, it will not change on the `referenceClone` instance. This is because we are now doing a deep copy clone using the `Codable` protocol.

## Conclusion
There you have it! Simple, automatic, and free deep copy clones using the `Cloneable` and `Codable` protocols. If you'd like to try this approach then take it for a spin by cloning[^3] my `Cloneable` repository on GitHub [here](https://github.com/DandyLyons/Cloneable). (It's also available as a SPM package.) And if you like it, please star it and share it with your friends!

[^3]: Ahem. Git cloning that is. 😄 I couldn't resist.

---
## Further Reading
- [Difference between Shallow and Deep copy of a class - GeeksforGeeks](https://www.geeksforgeeks.org/difference-between-shallow-and-deep-copy-of-a-class/) 
- This article is very much inspired by the JavaScript function `structuredClone()`. See it at [MDN Web Docs: structuredClone](https://developer.mozilla.org/en-US/docs/Web/API/Window/structuredClone)
- Here's a tutorial on using the _old_ Swift method of deep copying (using NSCopying): [Understanding Deep and Shallow Copying in Swift](https://ankur098.medium.com/understanding-deep-copy-and-shallow-copy-in-swift-8df201375611) 