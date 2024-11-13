---
title: 'Gradual Static Typing in GDScript'
slug: gradual-static-typing-in-gdscript
date: 2024-11-13
topics: ["Type Systems", "GDScript"]
description: Static or dynamic types? How about neither? Let's learn how GDScript's type system works. 
---

Any time we learn a new programming language, one of the first things we tend to fixate on is the syntax. But in many ways syntax is actually less important. The syntax is effectively the UI of the programming language. It's how the language "looks". But learning a language also requires understanding how a language "works".

One of the first and most important things that we should learn about a programming language is its **type system**.[^1]. 

[^1]: Type systems are kind of important to me. If you haven't noticed, I named this blog **Strongly Typed**. It's also a pun. Please laugh. Today, we'll be looking at one aspect of type systems: **static vs. dynamic typing**. We'll learn about each and then we'll see how GDScript has a very unique type system.

## What Is A Type System

First let's get on the same page about type systems. This article will be talking at a very broad, high-level about type systems. In short, a type system is effectively **formatting for your data**. 

You're probably familiar with formatting in text. Text can be **bold** or _italicized_ or <u>underlined</u>. These are part of the format of your text. Sometimes we move text from one app to another and our text looks all funky. This is because the two apps are using different formatting. One of the apps doesn't understand the formatting of the text and so it renders it incorrectly. **You can think of formatting as "how something is organized".**

Data can also be formatted (or organized) in a certain way, and in programming languages we call these **types**. Let's say you were writing code that stores a list of people's names. Should you store just their first name? Last name? Their full name? Should their full name be stored together or should they be in separate fields? From a human perspective, these questions are trivial and silly. But from a data perspective, these are very meaningful and important. For example look at this really bad Swift code:

```swift
let peopleString = "Alice Allison, Bob McBlob, Cher"

func greetEveryone(_ peopleString: String) {
    let fullNames: [String] = peopleString.split(separator: ",")
        .map { String($0) }
    for fullName in fullNames {
        let nameParts = fullName.split(separator: " ") 
        let lastName = nameParts[1]
        print("Hello, Mr or Ms. \(lastName)!")
    }
}

greetEveryone(peopleString)
```

That code prints the following:

```
Hello, Mr or Ms. Allison!
Hello, Mr or Ms. McBlob!
Swift/ContiguousArrayBuffer.swift:675: Fatal error: Index out of range
```

That's right! This code **crashes**. 🧨 Why? Because the code was trying to read the second item from `nameParts` in order to get the last name. But Cher doesn't have a last name! This code makes the incorrect assumption that everyone has exactly two names.

One solution to this problem is to use a type system...

## Static Type Systems

A static type system is one where the types of variables are determined at compile-time. This means that the compiler can check the types of your variables and expressions and ensure that they make sense. Here's an example of a simple static type system in Swift:

```swift
struct Person {
    let firstName: String
    let lastName: String
}

struct Individual {
    let fullName: String
}
```

In this example, we've defined two structs: `Person` and `Individual`. The `Person` struct has two properties: `firstName` and `lastName`, both of which are `String` types. The `Individual` struct has a single property, `fullName`, which is also a `String`.

When we use these types in our code, the compiler can ensure that we're using them correctly. For example, if we try to assign a `Person` to an `Individual`, the compiler will give us an error:

```swift
let alice = Person(firstName: "Alice", lastName: "Allison")
let aliceAsIndividual: Individual = alice // Error: Cannot convert value of type 'Person' to expected argument type 'Individual'
```

The benefit of a static type system is that it catches these kinds of errors at compile-time, before your code even runs. This can save you a lot of headaches and bugs.

### The Problem With Static Type Systems

The downside of static type systems is that they can be a bit more verbose and require more upfront work. In the example above, we had to define the `Person` and `Individual` structs, which is more code than just using a string to represent a person's name.

Additionally, static type systems can sometimes be too rigid. What if we want to represent a person who only has a single name, like "Cher"? We'd have to either shoehorn that into our `Person` struct or create a new `SingleNamePerson` struct. This can lead to a lot of boilerplate code.

## Dynamic Type Systems

The alternative to static type systems is dynamic type systems. In a dynamic type system, the types of variables are determined at runtime, not at compile-time. This means that the compiler doesn't check the types of your variables and expressions - that's left up to the runtime.

JavaScript is a classic example of a dynamic type system. In JavaScript, you don't have to declare the type of a variable - you can just assign any value to it, and the runtime will figure out the type:

```javascript
let person = "Alice Allison"; // person is a string
person = 42; // person is now a number
person = true; // person is now a boolean
```

The benefit of a dynamic type system is that it's more flexible and allows for more dynamic and expressive code. You don't have to worry about defining types upfront, and you can easily change the type of a variable as needed.

### The Problem With Dynamic Type Systems

The downside of dynamic type systems is that they can lead to more runtime errors. In the example above, if we accidentally tried to treat `person` as a string when it was actually a number, we'd get a runtime error. With a static type system, the compiler would have caught that error ahead of time.

Dynamic type systems also make it harder to reason about the structure of your data and the behavior of your code. Without clear type definitions, it can be difficult to understand what a piece of code is doing and how it's using its data.

## The Trade Off Between Static and Dynamic Type Systems

Both static and dynamic type systems have their pros and cons. Static type systems provide more compile-time safety and better tooling support, but can be more verbose and rigid. Dynamic type systems are more flexible and expressive, but can lead to more runtime errors and make the code harder to reason about.

Many programming languages try to find a balance between these two extremes. For example, TypeScript is a superset of JavaScript that adds optional static typing on top of the dynamic type system. This allows developers to get the benefits of both static and dynamic typing, depending on their preferences and the needs of the project.

## How GDScript Approaches This Problem
So now that we have a lay of the land, let's look at how GDScript handles this problem. Is GDScript a dynamic or statically-typed language? The answer is neither. According to GDScript's docs:

> GDScript is a high-level, object-oriented, imperative, and gradually typed programming language built for Godot.

What is a _gradually typed programming language_? Gradual typing is a type system that allows for a mix of static and dynamic typing within the same codebase. This means that, by default all your values are dynamically typed, **but you can opt-in to static typing** where it's beneficial, while still maintaining the flexibility of dynamic typing in other parts of your code.

### Introducing Gradual Typing in GDScript
You can leave the type out of a declaration, and GDScript will infer the type at runtime:

```gdscript
var name = "Alice"
var age = 30
```

But this also means that you can **change** the type at runtime as well: 

```gdscript
name = 30
age = "Alice"
```

And that means that it's now your responsibility to always check, at runtime, that you are receiving the type that you expect. The compiler won't help you check types. Unless...

In GDScript, you can declare variable types using the `:` syntax, like this:

```gdscript
var name: String = "Alice"
var age: int = 30
```

Now you are explicitly telling the compiler which type you expect, and the compiler will enforce that for you: 

```gdscript
name = 30 # 🔴 Error!
age = "Alice" # 🔴 Error!
```

This approach to typing allows GDScript to provide the benefits of static typing (type safety, better tooling support, better performance) while still maintaining the flexibility of dynamic typing. Developers can choose to use static typing where it makes sense, and dynamic typing where it's more convenient.

### Rough Edges of Gradual Typing in GDScript

While gradual typing is a clever solution that tries to give us the best of both worlds, it comes with its own set of challenges. Let's look at some of the rough edges in GDScript's implementation.

#### Static And Dynamic Code Can Conflict With Each Other

When mixing static and dynamic typing in the same codebase, you can run into some unexpected behavior. Here's a simple example:

```gdscript
# Dynamically typed function
func get_player_name():
	if true:
		return "Alice"
	else:
		return 2

# Statically typed function
func greet_player(player_name: String) -> void:
	print("Hello, " + player_name + "!")

func foo():
	# GDScript should not allow me to do this...
	greet_player(get_player_name())
```

Here `greet_player()` only accepts a `String`, and `get_player_name()` may or may not return a `String` so it shouldn't be allowed... but it is. 

#### GDScript Has No Generics

GDScript has no support for generics. This means that it's very difficult to express certain ideas in GDScript's type system. This is particularly important when it comes to `Array` and `Dictionary`.

For example, in a language with generics like Swift, you might write:

```swift
let numbers: Array<Int> = [1, 2, 3];
let names: Array<String> = ["Alice", "Bob", "Charlie"];
```

But in GDScript, you're limited to:

```gdscript
var numbers: Array = [1, 2, 3]  # Could contain anything!
var names: Array = ["Alice", "Bob", "Charlie"]  # Could contain anything!
```

Now you can be a little more specific with Arrays. You can add something that looks like generics, and even provides some extra type checking but it's not enforced everywhere you think it would be. 

```gdscript
var numbers: Array[int] = [1, 2, 3]  # Must contain ints
var names: Array[String] = ["Alice", "Bob", "Charlie"]  # Must contain Strings. 
```

But do not be fooled. This isn't quite the same thing as generics. It's like a pseudo-generics. It provides type checking for the elements, but it doesn't for example provide different methods. For example `Array[int]` can't have a separate `sum()` method that isn't available on `Array[String]`. 

## Conclusion
So there you have it. Gradual typing in GDScript. This was a very pleasant surprise for me when learning this language. But the truth is I'm still early in learning this language. I'm sure there are many other rough edges that I've yet to discover, but I haven't yet determined which are actually a rough edge, and which are my user error.

Please feel free to give me feedback on this article, and tell me anything that I don't understand correctly about GDScript. You can find me on [mastodon](https://iosdev.space/@dandylyons). 

## Recommended Reading
- [Gradual typing (Wikipedia)](https://en.wikipedia.org/wiki/Gradual_typing)