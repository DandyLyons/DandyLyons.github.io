---
date: 2024-10-22
title: "A Deep Dive into Value and Reference Types in Swift"
slug: swift-value-reference-deep-dive
images: [""]
description: 
topics: ["Swift", "C", "Pointers"]
---

# A Deep Dive into Value and Reference Types in Swift

Understanding how Swift handles memory and data is key to writing efficient, bug-free code. In this post, we'll explore the differences between value and reference types, and more importantly, what value and reference **semantics** mean in Swift. By the end, you'll know how to think about these concepts when designing your own Swift code.

## Value vs. Reference Types

Let’s start with an analogy that can help illustrate the difference between value and reference types: a library. Most libraries today have both physical books and digital books.

- **Value type**: This is like taking a physical book off the shelf. Only one person can hold the book at a time, and if you want to share it, you need to make a copy. Each person has their own independent copy of the book. If a person decides to write notes in their copy, it doesn’t affect anyone else's copy of the book.
  
- **Reference type**: But many libraries also lend out digital books (through services like Kindle). When you borrow a digital book, your device downloads the book from a server. Everyone's device downloads the same digital book from the same server. If the server makes a change to the book, everyone sees the updated version.[^1]

[^1]: Of course the analogy doesn't perfectly match, and I am glossing over some complexities of cloud infrastructure. For example, when you download a digital book you are technically making a new copy (value type), but your device will periodically sync changes from the server onto your device (which is like reference semantatics, which we'll talk about later). 

This difference between **independent copies** (value types) and **shared instances** (reference types) is at the heart of how Swift manages memory. 

## Value vs. Reference Problems
### The Reference Type Problem
In the early 2000s, the world slowly started to see the value of digital books. They save on paper. They take up no physical space. They don't mold or rot. They are virtually free to make infinite copies of. However, in 2009, the world realized a potential problem with digital books when Amazon [bizarrely chose to remotely delete copies of George Orwell's "1984"](https://www.pcworld.com/article/519855/amazon_kindle_1984_lawsuit.html) in Kindles all across the United States. (It turned out that Amazon realized that they didn't have the rights to sell the book in the United State.)

This is very similar to an old computer science problem, sometimes called [spooky action at a distance](https://en.wikipedia.org/wiki/Action_at_a_distance_(computer_programming)). When a reference type's value changes, this change affects every piece of code that is holding onto the same reference. Imagine reading a book, and the words on the page can change, regardless of if you are reading the book. This happens all the time in reference types. 

Swift has many different ways to tackle this problem, some of which we'll learn about here today. But one of the biggest ways that Swift tackles this problem is by simply avoiding reference types altogether. Swift prefers value types over reference types, because they are independent copies of a value not shared mutable state. This means you can read a value type and be confident that someone else isn't going to change the value right under your nose. 

### The Value Type Problem
To be clear, **value types are not inherently better than reference types**. While value types can be easier to understand and reason, they can also be very wasteful. Every time we create a value type we are creating an entirely new value. This requires more memory and compute to copy. 

By analogy, everyone could buy their own individual copy of a movie on Blu-Ray (value type). But this could be wasteful. Each person might watch the movie only once, if at all. Another approach could be to get a streaming subscription (reference type) like Netflix. Now each person effectively has their own reference to the same movies. 

## How C Handles This Problem: Pointers

It's important to understand that this is not a unique problem. Every programming language encounters this same problem and implements their own solutions, with their own set of tradeoffs. By learning how other languages handle the same problem, we can better understand the problem itself, and what Swift is doing under the hood. In particular, it is vital to understand how C solves this problem: pointers. In C, you can create value types just like in Swift. But you can also create pointers which _point_ to other values. When you go to the library and look up a book on the computer catalog, they will give you something like a dewey decimal number. This number is a pointer to the physical book (like a reference type). You can take this number to the shelf and find the book (the value type).

In C, these pointers are actual numbers representing the actual physical location where the value is stored on RAM hardware. This is just like a catalog number on a library bookshelf. One thing I like about this approach is it is very easy to tell when I am using a reference type and when I'm using a value type. In C, if I add a `*` to my variable name, then this is a pointer (reference). If there is no `*` then it is a value. 
 
```C
#include <stdio.h>

int main() {
    int x = 10; // x is a value type, integer with the value of 10
    int *y = &x; // y is a pointer to x
    *y = 20; // x is now 20
    printf("%d\n", x); // Prints: 20
    return 0;
}
```

The problem with C's approach is it is very dangerous. It is easy to make mistakes, and very easy for attackers to exploit weaknesses in your code that could have catastrophic effects. 

Swift abstracts away these details. Instead of exposing raw memory addresses and manual memory management, Swift provides higher-level concepts (value and reference types) to give you the power of C, while also providing safety. But it is important to remember that [Abstractions do not reduce complexity. They delegate it.]({{< ref "post-18">}}) In other words, while Swift's approach makes some things simpler, it also makes other things more complex. There is always a tradeoff. 

For example, remember that in C, it is very easy to tell if a variable is a reference or value type. Just look for the `*` operator. In Swift, it is not so simple. At the type level, it's usually pretty easy to tell, but at the call site, there is basically no indication. 

## How Swift Handles This Problem

### What Value and Reference Types Mean

In Swift, value and reference types are defined at the type level, and the Swift compiler enforces how they behave.

- **Value Types**: In Swift, structs, enums, and tuples are value types. When you assign or pass a value type, a copy is created. When a change is made to one copy, all the other copies are unchanged. These types typically live on the stack, which tends to make access faster
  
- **Reference Types**: Classes, actors, and closures in Swift are reference types. When you assign or pass a reference type, you're passing a reference to the same object in memory, not a copy. These types live on the heap, and multiple variables can reference the same instance. If one reference changes the instance, all references see the change.

```swift 
struct PhysicalBook {
    var title: String
}

var myPhysicalBook = PhysicalBook(title: "Swift Programming")
var yourPhysicalBook = myPhysicalBook  // Copies myPhysicalBook into yourPhysicalBook
yourPhysicalBook.title = "Swift Programming 2.0" // Doesn't affect myPhysicalBook. Only yourPhysicalBook is updated
print(myPhysicalBook.title)  // Prints: Swift Programming

class DigitalBook {
    var title: String
    init(title: String) {
        self.title = title
    }
}

var myDigitalBook = DigitalBook(title: "Swift Programming")
var yourDigitalBook = myDigitalBook  // Both myDigitalBook and yourDigitalBook refer to the same instance
yourDigitalBook.title = "Swift Programming 2.0"  // Both myDigitalBook and yourDigitalBook are updated
print(myDigitalBook.title)  // Prints: Swift Programming 2.0
print(yourDigitalBook.title)  // Prints: Swift Programming 2.0
```

#### Key takeaways:
- **Value types** imply **independent copies**.  
  - when you see `struct`, `enum` or a tuple, think value type
- **Reference types** imply **shared instances**.
  - when you see `class`, `actor`, or a closure, think reference type

However, as we'll see next, **these are general guidelines**, and should not be viewed as true in every case. The reason is because Swift allows us to mix value and reference types. 

## Mixing and Matching Value and Reference Types

In Swift, a reference type can hold onto value type properties. Likewise a value type can hold onto reference type properties. 

### Using Value Types Inside Reference Types

Consider an example of a `Rectangle` class that holds its size and position using value types (`Size` and `Point`):

```swift
struct Size {
    var width: Int
    var height: Int
}

struct Point {
    var x: Int
    var y: Int
}

class Rectangle {
    var origin: Point
    var size: Size
    
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
}
```

How should we think of `Rectangle`, as a reference type, or as a value type? The answer is it depends on the context. "Outside" of the `Rectangle` we can think of it as a reference type because it is a class, but "inside" the `Rectangle`, we can think of its properties as value types. 

```swift
class Rectangle {
    // ...
    var size: Size
    var area: Int {
        size.width * size.height
    }
}
```

Because `Size` is a `struct` we can confidently calculate the area without worrying that somebody changed the value under our nose. Even though `Rectangle` is a reference type, each `Rectangle` holds onto its own individual copy of `size` and therefore it can't be changed by someone else. If `Size` were a class then we would have to think of it as a reference type.

### Using Reference Types Inside Value Types

On the flip side, reference types can also be embedded within value types, and this is where things can get interesting. While value types generally exhibit copy behavior, they don’t always **copy** everything inside them. If a value type contains a reference type, **the reference to the object is copied, not the object itself**. This subtle difference can lead to unexpected behavior if you're not careful.

```swift
class Node {
    var value: Int
    init(value: Int) {
        self.value = value
    }
}

struct LinkedList {
    var head: Node
    
    init(head: Node) {
        self.head = head
    }
}

var node1 = Node(value: 10)
var list1 = LinkedList(head: node1)

var list2 = list1  // Copy the LinkedList struct
list2.head.value = 20  // Change value inside the reference type

print(list1.head.value)  // Prints: 20
print(list2.head.value)  // Prints: 20
```

Here, we have a `LinkedList` struct, a value type, that holds a reference to a `Node` class. When we copy `list1` into `list2`, we create a new instance of `LinkedList`, but since the `head` property is a reference type, both `list1` and `list2` share the same `Node`. Changing the `Node` inside `list2` affects the `Node` inside `list1` as well. 

This behavior shows how **copying a value type doesn’t necessarily mean copying all of its contents**. If those contents are reference types, only the reference is copied, leading to shared state. It’s crucial to be aware of this when embedding reference types in value types, as it can cause unexpected side effects.

## What Value and Reference Semantics Mean

The terms "value types" and "reference types" describe **what** something is. But value and reference **semantics** describe **how** they behave.

- **Value semantics**: This means that when you interact with a type, you work with independent copies, regardless of whether it's implemented as a value type or a reference type under the hood. Types with value semantics avoid unintended side effects from shared mutable state, making your code more predictable. In Swift, types like `Array` and `Dictionary` behave like value types but are actually reference types under the hood, thanks to a technique called **copy-on-write**.

- **Reference semantics**: This occurs when a type shares its reference with others, meaning that changes made to one reference are seen by all others. This is typical of reference types like classes or actors, where the object’s state is shared across multiple references.

It’s important to note that the distinction between value and reference **types** is a language-level feature, enforced by Swift’s compiler. However, value and reference **semantics** are more of a language convention or pattern. So when a type is said to have _value semantics_, it means you can treat it **as if** it were a value type[^valueSemantic], but the compiler makes no guarantee that the type will correctly follow value semantics. 

[^valueSemantic]: and you don't have to care if it actually **is** a value type under the hood.

### Copy on Write
This next part is not necessary to understand Swift, but it can be helpful to understand more advanced use cases. 

Swift regularly uses a pattern called **copy-on-write (CoW)**. This is as an optimization to reduce the overhead of copying large value types like `Array`, `Dictionary`, and `Set`. Under the hood, these types are powered by reference types. When you copy an `Array`, for example, Swift doesn't immediately create a new copy of the underlying data. Instead, it keeps a reference to the same memory until one of the copies is modified.

When a modification occurs, Swift creates a new copy of the data before applying the change. This gives you the benefits of value semantics (each copy is independent), without the performance hit of copying large amounts of data unnecessarily. In short, **CoW is a way to make reference types behave as if they were value types**. In other words, **CoW is a way to implement value semantics**. `Array` is an example of a type that has value semantics, and yet under the hood it is implemented as a reference type. 

Let’s look at an example:

```swift
var array1 = [1, 2, 3]
var array2 = array1  // No copy happens here
array2.append(4)     // Now the copy is made, and array2 is modified

print(array1)  // Prints: [1, 2, 3]
print(array2)  // Prints: [1, 2, 3, 4]
```

In this example, the copy of `array1` only happens when `array2` is mutated. This is the essence of copy-on-write. In practice, you shouldn't need to know or care about CoW when you are using a type. The type should handle it for you. 

## How to Think About Value and Reference Types in Swift

### At the Declaration Site

When you declare a type, you should think about whether you need independent copies or shared references.

- Use **value types** (e.g., `struct`, `enum`) when you want each instance to be independent, and changes made to one instance shouldn't affect others. Value types are great for things like data models, where predictability and immutability are important.
  
- Use **reference types** (e.g., `class`, `actor`) when you want to share state between different parts of your program. Reference types are ideal for things like managing global state or objects that need to be modified by multiple clients.

- Use a **value type that holds onto reference types**, when you need features that can't be implemented in a value type. But when you do, you should probably implement value semantics (by using CoW), otherwise you will confuse your API users. 

### At the Call Site

Whether you are using a value or reference type will dramatically change how your code behaves. Unfortunately, Swift doesn't make it super easy to know which one your type really is. 

```swift
var p1 = Point(x: 0, y: 0) // Is Point a value or reference type? 🤷🏼‍♂️
var p2 = p1  // Are we copying the value or the reference? 🤷🏼‍♂️
p2.x = 10 // Did we change just p2 or did we change both? 🤷🏼‍♂️
```

Like we said before, in general, you can tell if it's a reference type by checking if it's a struct or class. But there are two major problems with this. The call site doesn't tell you if it's a class, so you need to look at the declaration site or the documentation. But the second problem is much bigger. Even if you know that the type is a struct, you still don't know that it's a value type. 

Swift developers will often say that you should understand if a type is a reference or value type. In my opinion, this is incomplete advice. **What you should actually care about is if the type follows reference or value <u>semantics</u>**. Remember a value type can hold onto reference types. This means that in certain circumstances they will behave like reference types (i.e. they will have reference semantics). So it can be very difficult and time consuming to determine if a type uses reference or value semantics. Worse yet, the compiler makes no attempt to guarantee value or reference **semantics**. 

## What's the solution? 
So what's the solution? Unfortunately, today I don't really have one. This is an actual pain point for me in using Swift. However, I do have some guidelines to help: 

1. Care less about if a type is a value **type** and care more about if it follows value **semantics**.
   - Unfortunately, this distinction can be quite subtle and I hope that this article helps make the distinction clearer. Worse yet, type **semantics** are often undocumented, and there often isn't a way to determine it without reading the source code, or running tests. 
2. Avoid using reference types if they are not necessary: 
   - This is standard Swift practice, but unfortunately it's not always feasible. If you're using an OOP framework like UIKit, you simply must interact with reference types. 

## Conclusion

Understanding the distinction between value and reference types (and more importantly how they behave) helps you write more predictable and efficient Swift code. Value types are ideal when you want independent copies of data, while reference types are useful when you need shared, mutable state.

By mastering these concepts, you’ll be better equipped to make informed decisions about your code’s structure and performance.



















