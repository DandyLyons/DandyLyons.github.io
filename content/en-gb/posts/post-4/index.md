---
title: Explicit and Implicit Types in Swift
slug: explicit-implicit-types-in-swift
date: 2024-03-16
draft: false
series:
  - Swift Generics Demystified
topics:
  - Swift
  - Generics
url: /posts/swift-generics/explicit-types-swift
images:
  - image.jpg
description: Let's learn how Swift infers types.
tags:
  - Swift
---
Generics are one of the most powerful features in Swift, yet they can often feel overwhelming, even for seasoned Swift developers. In this series we'll learn how to make generics simple, useful, and even fun!
### Back to Basics
But to start off, we'll look somewhere you probably won't expect: declaring variables. 
```swift
let strings = ["John", "Paul", "George", "Ringo"]
let oneLongString = strings.joined(separator: ", ") 
```
This seemingly simple piece of code has some hidden functionality. Consider for a second, what type is `strings`. That's easy. It's an `Array`. But that answer is only half correct. Notice, how does `strings` know about the `joined` method? How does it know how to join the elements? What if that was an array of numbers?. Here, most Swift developers would say that the answer is [Type Inference](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/types/#Type-Inference). And while that answer is technically correct, it's still missing part of the story. 

The problem with simply saying that it's Type Inference is that it feels like magic, and while Swift certainly feels magical, it most certainly is **not** magical (and that's actually a good thing). Magic, may produce joy, surprise, and wonder but it is also mysterious, unpredictable, and impossible to understand. So, how did Swift infer the type for the `strings` variable? Was it just really smart? No, absolutely not. The first step to understanding Swift, the Swift type system, and Swift generics is learning this lesson: 

> Swift is not magic, even when it feels like it is. Every single thing it does has a predictable reason. 

Sorry to wax philosophical on you, but the sooner that we learn this lesson, the sooner generics will make sense to us. So, finally, let's answer the question. How does Swift know that `strings` is an `Array`. The answer is: you said that it was! Swift found the type from the value, and assigned that same type to the variable. 

```swift
["John", "Paul", "George", "Ringo"] // this is an `Array` Literal. 
// by assigning an Array literal to `strings`, Swift has "inferred" that 
// strings must be an Array. 
let strings: Array = ["John", "Paul", "George", "Ringo"]
// it's as if you 👆🏼 actually declared the type right here
```

### Explicit vs. Implicit types

Try it for yourself. Declare an Array like so: 
```swift
let strings = ["John", "Paul", "George", "Ringo"]
```
and then *afterwards*, declare the type explicitly like this: 
```swift
let strings: Array = ["John", "Paul", "George", "Ringo"] 
// notice how there's no error
```
Now, let's see what happens if we use a different type. 
```swift
let strings: Dictionary = ["John", "Paul", "George", "Ringo"] 
// Error: Dictionary of type 'Dictionary' cannot be initialized with array literal
```
Why did we get an error? Because we gave Swift two conflicting instructions. We said that `strings` is a `Dictionary` but we didn't give it a `Dictionary`, we gave it an Array literal, which is an `Array`. So, which one is it? Is `strings` an Array or a Dictionary? The answer is Dictionary. Notice how the error says `Dictionary of type 'Dictionary' cannot be initialized with array literal` and it doesn't say something like `Array cannot be type casted into Dictionary`. 

**The point is that this line has not one but 2 type declarations (explicit on the left, and implicit on the right) and they have to agree with each other. No exceptions.** So remember this principle: 

>Swift is a **very** strongly typed language. In other words, it won't allow you to break the rules. Learn how to follow the rules, or your code simply won't compile. 

Or a better way of thinking of it is: "Swift's got your back and will protect you from making silly mistakes".

### Generic Types
But we still haven't answered one question, how does `strings` know what the `joined` method is? Is it just a method on `Array`? Nope. 
```swift
let strings: Array = ["John", "Paul", "George", "Ringo"]
let oneLongString = strings.joined(separator: ", ") // no Error

let numbers: Array = [3, 4, 5]
let maybeOneLongNumber = numbers.joined(separator: ", ") // Error: No exact matches in call to instance method 'joined'
```
This is because `strings` and `numbers` are not the same type even though they are both `Array`s. `strings` is type `Array<String>` and `numbers` is type `Array<Int>`. See those `<`angle brackets`>`? Those are generics. This is because `Array` is a generic type. To illustrate my  point, let's look at the definition of Array. Right-click `Array` and choose "Jump to Definition". 
```swift
@frozen public struct Array<Element> {
// ...
}
```
What's `Element`? It's a [type parameter](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/genericparametersandarguments/). It's kind of like Swift is saying "I have this type called `Array` that can hold some other type (let's call it `Element`), but you, the programmer, get to decide which type `Element` will be". This is why, for some, it might be unhelpful to call this *type inference*. *Type inference* seems to imply that Swift just sort of "figured out" what the type is. But that really isn't what happened. Swift didn't "figure it out", you told Swift what the type was (either explicitly or implicitly). 

```swift
let strings = ["John", "Paul", "George", "Ringo"] // implicit type declaration of Array<String>
let numbers: Array<Int> = [3, 4, 5] // explicit type declaration
```


> **Tip:** `[String]` is syntactic sugar for `Array<String>`.
> Note that Array is special in that it has [two ways](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/types#Array-Type) to explicitly declare its type. `[String]` and `Array<String>` which both mean the same thing. 


The moral of the story is: 

>Swift Generics are everywhere in Swift. If you don't understand generics, then you won't understand Swift. 

### Think of Swift as your pair programmer

Finally, let's leave you with something that is actually useful for you. SwiftUI often feels magical until you get hit with one of these kinds of errors. 

```swift
struct Contact: Identifiable {
  let id: UUID
  var name: String
}

struct BottomBarView: View {
  @State private var contacts = []
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(self.$contacts) { contact in 
		          // 👆🏼 🛑 Cannot convert value of type 'Binding<[Any]>' to expected argument type 'Range<Int>'        
          TextField("Name", text: contact.name) 
									   // 👆🏼 🛑 Value of type 'Int' has no member 'name'          
        }
      }
      .navigationTitle("Contacts")
    }
  }
}
```

Why does Swift think that name is an `Int`. And why is `ForEach` expecting a `Range<Int>`? Moments like this can be extremely frustrating. Worse, yet, they are very difficult to search for an answer since you're error message is likely to be too specific to your code. Even worse still, there is no way to debug this problem since our code isn't even compiling. Moments like this can make us want to scream at the compiler, but instead **why don't we try having a *conversation* with it?** 

Notice how the first message `Cannot convert value of type 'Binding<[Any]>' to expected argument type 'Range<Int>'` starts with `Cannot convert value`? In my experience, **this almost always means that there is some sort of type mismatch**. In other words, the type that I think I'm using and the type that the compiler determines I'm using are actually different types. 

>Us: Hey Swift, what is the type?

What is the type of `self.$contacts`? Isn't it `Array`? Swift already knows that it's an Array because I assigned an Array literal (`[]`). But don't forget, `Array` is a generic type. This means that it's actually not complete to say that it's an Array. Let's ask the compiler "What kind of Array is it?" Right-click the `contacts` variable after `@State private var` and choose "Show Quick Help".  Hopefully, if Xcode doesn't fail[^1], it should show the following: 

```swift
@State var contacts: [Any] { get nonmutating set }
```

[^1]: In my experience, Xcode will often fail when I click "Show Quick Help", instead of displaying "No Quick Help". If you can find any tips to make Quick Help more reliable, please let me know on social media. 

>Swift: It's an `[Any]`.

As you can see `contacts` is not a `[Contact]` but instead a `[Any]`. You might say that Swift *inferred the wrong type* but that's not very helpful. I think it's more accurate to say that **we did not give Swift enough information**.

>Us: Actually Swift, could you make sure that is a `[Contact]`, please.

```swift
@State private var contacts: [Contact] = []
```

And *voila* all of the errors should be gone now! Before, we didn't give Swift enough information to know what type contacts was, so Swift essentially had to fallback to a default type. In this case Swift fell back to `[Any]` and this produced a whole host of problems. For example, `ForEach` creates a view for each element in our contacts array, and we named that element `contact`. But because `contacts` was `[Any]` that means `contact` was `Any`, and this produced the error. `Any` has no parameter `name`. 

But afterwards we *explicitly* said that the type is `[Contact]`. Now, that Swift has more information, it can tell that `contact` is a `Contact` and therefore has a `name` property. 
### Takeaways
Ask yourself "What type does Swift think this variable is and is that the same type I'm expecting."

If your code won't compile, the reason why is often going to be because of an incorrect type somewhere in your code. **Try explicitly declaring the type of your variables to see what will happen.** Many times, this will give Swift just the amount of info that it needs. Other times, you might discover that the type wasn't what you assumed it was. This doesn't mean that you should explicitly type everything, nor does it mean that you should avoid type inference. Type inference in many instances can lead to code that is easier to read, maintain, understand and is even safer. 

But sometimes you and Swift will understand each other more if you just talk to each other. 

[Next time]({{< ref "post-5" >}}), we start learning about generics in Swift. 