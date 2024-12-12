---
title: Forcing Value Semantics in Swift
description: How to force value semantics in Swift. 
date: 2024-12-10
tags: ["Swift", "Value Semantics"]
draft: true
---

In most programming languages, there is some concept of value and reference types. In Swift, we prefer to use value types and value semantics whenever possible. This is because value types are easier to reason about since they cannot be mutated by other parts of the code.[^1] However there are some times when we must use reference types. Is there a way to get our reference types to behave like value types? Yes, there is.

[^1]: To be clear, value types are not better or worse than reference types. They both have very valid use cases.

## Value Semantics vs. Reference Semantics
Let's do a quick recap of value semantics and reference semantics. Remember that value semantics means that when you copy a value, you get a **new copy of the value**. This is in contrast to reference semantics where when you copy a reference, you get a **new reference to the same object**.

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

But one of the cool things about reference types is that we can force them to behave like value types, by copying their values instead of their reference. When a reference type **behaves** like a value type we call this _value semantics_. Swift regularly does this through a strategy called _copy-on-write_, but let's look at another way to accomplish this.

## Cloning A Reference Type
One way to force a reference type to behave like a value type is to clone it. Notice I said _clone_ and not _copy_. When you clone a reference type, you are creating a new instance of the reference type with the same values. This way, you can change the values of the cloned reference type without affecting the original reference type. 

```swift
var reference1 = ReferenceType(int: 1)
var reference2 = ReferenceType(int: reference1.int)
reference2.int = 2
print(reference1.int) // 1
print(reference2.int) // 2
```

Here we created an entirely new instance of `ReferenceType` and copied the value of `reference1` into `reference2`. Now, when we change the value of `reference2`, it will not affect `reference1`. This strategy is useful but can be quite cumbersome if we have many values. Let's enforce this behavior through a new protocol name `Clonable`.

```swift
protocol Clonable {
    init(cloning original: Self)
    func clone() -> Self
}
extension Clonable {
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

Now, we can enforce value semantics on our reference type by making it conform to the `Clonable` protocol. This way, we can guarantee that when we clone the reference type, we get a new instance of it with the same values.

```swift
extension ReferenceType: Clonable {
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

Unfortunately this is a little extra work to maintain. If our `ReferenceType` ever changes we must remember to update the `Clonable` protocol implementation as well. But the compiler should warn us if the initializer is incomplete. 

## Forcing Value Semantics Through Property Access
Suppose we have the following type: 

```swift
struct ContainerType {
    var referenceType: ReferenceType
}
```

Since this container type holds a reference type as its property, it will have reference semantics, which could lead to strange behavior. For example, the following code will print `2` for both `container1` and `container2`: 

```swift
var container1 = ContainerType(referenceType: ReferenceType(int: 1))
let reference = container.referenceType
var container2 = ContainerType(referenceType: reference)
container2.referenceType.int = 2
print(container1.referenceType.int) // 2
print(container2.referenceType.int) // 2
```

But we can force value semantics by making the property private and only allowing access to it through a computed property. Now, the following code will print `1` for `container1` and `2` for `container2`:

```swift
struct ContainerType {
    init(referenceType: ReferenceType) {
        self._referenceType = referenceType
    }
    private var _referenceType: ReferenceType
    var referenceType: ReferenceType {
        get {
            return _referenceType.clone()
        }
        set {
            _referenceType = newValue.clone()
        }
    }
}
var container1 = ContainerType(referenceType: ReferenceType(int: 1))
let reference = container1.referenceType
var container2 = ContainerType(referenceType: reference)
container2.referenceType = ReferenceType(int: 2)
print(container1.referenceType.int) // 1
print(container2.referenceType.int) // 2
```

By making the property private and only allowing access to it through a computed property, we ensure that it's impossible to change the value of the reference type without creating a new instance of it. This way, we can force value semantics on our property.

## Value Semantics On A Property Rather Than A Type

It's important to note however that we are not enforcing value semantics on the `ReferenceType` itself. The `ReferenceType` is still a reference type and will behave as such in other contexts. Instead we are enforcing value semantics on the property. We are guaranteeing that the property will always be a unique instance of the `ReferenceType` and **that unique instance** will not be mutated by other parts of the code. However, any copy of the `ReferenceType` that "leaves" the `ContainerType` will still be a reference type and will behave as such.

```swift
var container = ContainerType(referenceType: ReferenceType(int: 1))
let exportedReference = container.referenceType
let copyOfExportedReference = exportedReference
copyOfExportedReference.int = 2
print(container.referenceType.int) // 1
print(exportedReference.int) // 2
print(copyOfExportedReference.int) // 2
```

## Room For Improvement
As great as this solution is, there is still a major usability issue. It only works when we replace the entire property, the reference type, with a new instance. But it doesn't work when we want to change a property of the reference type directly. For example, the following code will print `1` for both `container1` and `container2`:

```swift
var container1 = ContainerType(referenceType: ReferenceType(int: 1))
var container2 = container1
container2.referenceType.int = 2
print(container1.referenceType.int) // 1
print(container2.referenceType.int) // 1
```

This is because we didn't really use the setter on `referenceType`. We just changed a property of the `ReferenceType` directly. Perhaps we can make this more usable by using `@dynamicMemberLookup` to allow us to access the properties of the reference type directly. Or perhaps we might be able to fix this using the `_read` and `_modify` accessors. 

The other usability issue is that we must write the getter and the setter in order to enforce value semantics. Perhaps we could have this boilerplate code generated for us autmoatically using a property wrapper or a macro. But all of that is a topic for another day.

## Conclusion
So, what have we accomplished? We've now guaranteed that our property will not have any side effects or spooky action at a distance. We've guaranteed that our property will always be a unique instance of the reference type and that unique instance will not be mutated by other parts of the code. And we did so without needing to create a new value type. 

We've also made it relatively easy to clone an instance of a reference type via the `Clonable` protocol. This way, we can enforce value semantics on our reference type by making it conform to the `Clonable` protocol. 

Finally, we've made it easy to enforce value semantics on a property by making the property private and only allowing access to it through a computed property. This way, we can guarantee that it's impossible to change the value of the property without using the setter. 

Unfortunately, I wouldn't say any of this is a solution I'd be comfortable using in production code yet. Usability issues aside, I'm not sure what the perfect use case is just yet. Also, I'm not sure if this would break our mental model of value and reference semantics. But it's a fun thought experiment nonetheless, and perhaps it will inspire you to think of a compelling use case!