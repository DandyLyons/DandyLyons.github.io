---
title: 'Concrete and "Soft" Types in Swift'
slug: concrete-soft-types-in-swift
date: 2024-04-01
series: ["Swift Generics Demystified"]
topics: ["Swift", "Generics"]
url: "/posts/swift-generics/concrete-types-swift"
images: ["image.jpg"]
description: Learn what Swift means when it talks about "concrete" types. 
---
In our [last article]({{< ref "post-4" >}}), we learned about how the generics system is deeply integrated into Swift at practically every level. This can give us magical features that help like *Type Inference* which makes our code easier to read and right, but it can also lead frustrating and confusing compile-time errors. Furthermore, most modern Swift libraries are filled with generic code, especially in Apple first-party frameworks such as **SwiftUI**, **Combine**, and the recently announced **SwiftData**. I hope that I've made a strong case that **generics in Swift are simply too important to ignore**. So without further ado, let's dive into generics, albeit with a slightly different approach than you might expect. 

## Reading Generic Code
You might expect an article on Swift Generics to start with writing generic code, and in fact many fantastic authors have already covered this quite well. But perhaps a better approach would be to start with **reading** generic code. This is for a few reasons: 
1. By nature, generic code is generalized to multiple use cases. It takes work to understand **one** use case, let alone many. 
2. Generic code is quite abstract. 

So here is what we will do. Let's look at a few basic common types that are used throughout SwiftUI, and see what we can learn from them, starting with the most basic of them all, the humble [View](https://developer.apple.com/documentation/swiftui/view). 

### SwiftUI's `View`
Every single SwiftUI View has a `: View` after it's name like so: 
```swift
struct MyView: View {
	 var body: some View {
		 Text("Hello World")
	 }
}
```
In Xcode, right click on the word `View` and click "Jump to Definition". You should see something like this: 
```swift
public protocol View {

    /// ...
    associatedtype Body : View

    /// ...
    @ViewBuilder @MainActor var body: Self.Body { get }
}
```
What can we learn here about the `View` type? Well, that's a bit of a trick question. `View` isn't really a Type, exactly. It's a protocol. The Swift documentation says this: 

> ## [Protocols as Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/#Protocols-as-Types)
> 
> Protocols don’t actually implement any functionality themselves. Regardless, you can use a protocol as a type in your code.

Think of protocols as rules. In real life, if we follow certain rules, we get perks. If you pass the driving test, then you get the perk of being allowed to drive legally. Likewise, if your type conforms to the `View` protocol, then it now gets to do all the cool things that SwiftUI Views can do. But the View protocol doesn't actually do anything since it doesn't "actually implement any functionality".  **The Type that conforms to the `View` protocol is the actual thing that has properties and methods.**

### Introducing Concrete and "Soft" Types
If you look at the Swift docs on [Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/types/) and do a CMD-F search for "*concrete type*", you'll see that the phrase is used throughout. Unfortunately, though, I haven't yet found an official definition of what exactly *concrete type* means.[^1] But I think the definition is pretty clear from the context. **A concrete type is the *actual* type that will be used at runtime.** But if there's such a thing as *concrete types* then that implies that there are *non-concrete* types, types that aren't actually used at runtime. However, I haven't found an official name for these *non-concrete* types, so I'll refer to them as *soft types*. **A _soft type_ is a type isn't actually used at runtime. Instead, it gives instructions to Swift on how to find the _concrete type_.**  We can see an example of this in every SwiftUI View: 

[^1]: You might say that I haven't found a *concrete* definition of *concrete types*.

```swift 
var body: some View
```
The `body` property is explicitly typed using `:` but what is the type? `some View`. But `View` is not a *concrete type* since it's a protocol. Somewhere, Swift has to infer the *concrete type*. Remember, Swift is a strongly typed language so **everything** has a type. The answer is that this is an example of an [opaque type](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes). Essentially, we're telling Swift that body will be "some View". We're not telling Swift which specific type it will be. Instead, Swift will infer the type for us as long as we give it a type that conforms to `View`. For example: 

```swift
var body: some View { // `some View` is the soft type
	 Text("Hello World") // `Text` is the concrete type
}
// ...
var body: some View {
	VStack { // `some View` is the soft type
		Text("Hello World") 
	} // The concrete type is `VStack<Text>`
}
```

As you can see VStack is generic. Now try altering your `body` to look like this: 

```swift
struct MyView: View {
  var body: VStack { // 🛑 Error: Reference to generic type 'VStack' requires arguments in <...>

    VStack { // `some View` is the soft type
      Text("Hello World")
    } // The concrete type is `VStack<Text>`
  }
}
```

So I would say that `VStack` is also a *soft type*. In other words, even if Swift knows that it's a `VStack`, that is not enough information for Swift to infer the *concrete type*. In fact, every generic type is a *soft type*. Every time that we use a generic type, we have to make sure that we are giving Swift enough information to find the concrete type. This could get very tedious and error prone, and so that's why Swift gives us various tools like opaque types (the `some` keyword) to make this easier. 

```swift 
struct MyView: View {
  var body: some View { // `some View` is the soft type
    List { // ⭐ the concrete type is some gigantic nested monstrosity
      ForEach(0..<9) { num in
        VStack {
          Text("This is some text in a row cell.")
          Text("This is the current number: \(num)")
        }
      }
      .onAppear {
	      print("The type of MyView.body is \(type(of: self.body))")
      }
    }
  }
}
```

### `associatedType`: generics for protocols
Just as we can make types generic, we can also make protocols generic using the `associatedType` keyword. The [Swift docs says](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/): 
>When defining a protocol, it’s sometimes useful to declare one or more associated types as part of the protocol’s definition. An _associated type_ gives a placeholder name to a type that’s used as part of the protocol. The actual type to use for that associated type isn’t specified until the protocol is adopted.

So just like how the `Array` type has a *generic type parameter* called `Element`, the `View` protocol has an *associated type* called `Content`. And as we can see in the definition, `Body` must conform to the `View` protocol. 

```swift
public protocol View {
    associatedtype Body : View
    @ViewBuilder @MainActor var body: Self.Body { get }
}
```

But don't forget `Body` is **not** a concrete type. It's a *soft type*, a placeholder for a type that conforms to `View`. **This means that every time you use a protocol with an associatedtype, you must tell the compiler what the associatedtype is.** 
So in the example below how are we telling Swift the type for `body`? 
```swift
struct MyView: View {
	 var body: some View {
		 List {
			 Text("Hello")
		 }
	 }
}
```

When we used the `:` we declared the type for `body` explicitly right? Well, no. Remember that the `some` keyword is also a placeholder, a *soft type*. No, the concrete type is actually `List<Text>` in this case, and so the `associatedtype` `Body` was implicitly[^2] evaluated to be `List<Text>`. 

### How to explicitly declare the `associatedtype`
If you recall, earlier we learned how to explicitly and implicitly declare generic types: 
```swift
let implicitArray = ["strings"]
let explicitArray: Array<String> = ["more strings"]
```

But did you know you can even do this for `associatedtype`s? 

```swift
struct MyView: View {
	typealias Body = Text // explicitly set the associatedtype
	var body: Text {
		Text("Hello")
	}
}
```

In practice, this wouldn't be the most practical way to do this, in this situation[^3], but there are some situations when it can be helpful. In fact this is often what Xcode will automatically do if you click a "Fix Me" button. 

[^3]: because we would have to remember to keep the types of `Body` and `body` in sync with each other.

If you write this: 
```swift
struct MyView: View { // 🔴 type 'MyView' does not conform to protocol 'View'
    // this is intentionally blank
}
```
... and then click the "Fix Me" button in the error, then Xcode will add this: 
```swift
struct MyView: View { // 🔴 type 'MyView' does not conform to protocol 'View'
    typealias Body = 
}
```
This is because, Xcode doesn't have all the information it needs to help you fulfill the protocol requirement yet. It doesn't know what type `Body` is. Now fill in `Body`...:
```swift
struct MyView: View { // 🔴 type 'MyView' does not conform to protocol 'View'
    typealias Body = Text
}
```
and click "Fix Me" one more time and Xcode will add this..."
```swift
struct MyView: View { // 🔴 type 'MyView' does not conform to protocol 'View'
    typealias Body = Text
    var body: Text
}
```

### Why not just explicitly type everything? 
Perhaps you are thinking, "Why can't I just explicitly type everything? Why do we need concrete and so-called soft-types?" In other words, why do we need type inference.  

There are a few reasons why type inference is powerful. As we established earlier, Swift's strongly typed system allows the compiler to guarantee that your code is safe and that certain bugs are impossible to write! 🎉 In addition, it allows the compiler to make some optimizations behind the scenes that make our code more performant, and we get all these benefits for free! 

But a strongly typed system is also more strict and cumbersome to use. It also requires more maintenance as our codebase evolves over time. For this reason, the Swift team decided to adopt a philosophy of design called Progressive Disclosure of Information. In other words, Swift will hide complexity until it is actually relevant and helpful, and one of the ways that they achieved this was through generics. Through type inference, the Swift compiler is empowered to handle a lot of the grunt work for us, and we can focus on only the things that we care about. For example, we don't need to explicitly tell Swift what the concrete type of `Body` is. But it is also nice to know that we have the power to be explicit, should the need arise. 
## Conclusion
In this article we learned about concrete types, and so-called *soft* types. We also learned how they can be used explicitly and implicitly. Once again, we've learned how the Swift compiler has your back and can prevent you from writing certain types of bugs. Furthermore, while the type system can produce some confusing error messages, that can feel very unhelpful, Swift become much more helpful when you "have a conversation with it". This can be done by explicitly setting types in order to see what errors are produced. 