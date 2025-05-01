---
draft: true
---


## Forcing Value Semantics Through Property Access in Swift
Earlier we explored [Easy Deep Cloning in Swift] using the `Cloneable` protocol. In this post, we'll explore how we can use the `Cloneable` protocol to enforce value semantics on a property in Swift.

Now that we have a way to clone our reference type, we can enforce value semantics on a property by making the property private and only allowing access to it through a computed property.

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

It's important to note however that we are not enforcing value semantics on the `ReferenceType` itself. The `ReferenceType` is still a reference type and will behave as such in other contexts. Instead we are enforcing value semantics on the property. We are guaranteeing that the **property** will always be a unique instance of the `ReferenceType` and **that unique instance** will not be mutated by other parts of the code. However, any copy of the `ReferenceType` that "leaves" the `ContainerType` will still be a reference type and will behave as such.

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

We've also made it relatively easy to clone an instance of a reference type via the `Cloneable` protocol. This way, we can enforce value semantics on our reference type by making it conform to the `Cloneable` protocol. 

Finally, we've made it easy to enforce value semantics on a property by making the property private and only allowing access to it through a computed property. This way, we can guarantee that it's impossible to change the value of the property without using the setter. 

Unfortunately, I wouldn't say any of this is a solution I'd be comfortable using in production code yet. Usability issues aside, I'm not sure what the perfect use case is just yet. Also, I'm not sure if this would break our mental model of value and reference semantics. But it's a fun thought experiment nonetheless, and perhaps it will inspire you to think of a compelling use case!