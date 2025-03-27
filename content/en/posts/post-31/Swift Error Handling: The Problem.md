---
title: "Swift Error Handling: The Problem"
date: 2025-03-27
tags: ["Swift", "Error Handling"]
series: "Swift Error Handling"
image:
description: "Explore the strengths and weaknesses of Swift's error handling system, and discover how it can be improved."
slug: swift-error-handling-the-problem
---

# Swift Error Handling: The Problem

Error handling is a fundamental aspect of robust iOS application development. As developers, we're constantly dealing with operations that can fail - network requests, file operations, data parsing, and user input validation. Swift provides a structured approach to error handling, but like any system, it has its strengths and weaknesses. In this first post of a three-part series, we'll explore the current state of Swift's error handling system, examining both what works well and what could be improved.

## The Good

Swift's error handling system has several notable strengths that make it superior to many other programming languages. Let's examine what Swift gets right.

### Clear Function Declarations with `throws`

One of Swift's best features is the explicit `throws` keyword that immediately signals a function might produce an error:

```swift
func fetchUserData(userId: String) throws -> User {
    guard let userData = database.fetchUser(withId: userId) else {
        throw UserError.notFound(id: userId)
    }
    return userData
}
```

This explicit declaration creates a clear contract: this function might fail, and callers need to be prepared for that possibility. There's no need to dig through documentation or implementation details to discover error-throwing behavior.

In Swift, we can be confident that any function that is not marked with `throws` will never throw an error, simplifying our mental model of the codebase. In contrast, languages like JavaScript or Python don't have this explicit signaling, leading to uncertainty about which functions might fail.

### Mandatory `try` Keywords at Call Sites

Swift forces you to acknowledge the potential for errors at every call site with the `try` keyword:

```swift
do {
    let user = try fetchUserData(userId: "12345")
    updateUI(with: user)
} catch {
    showErrorMessage(error)
}
```

This mandatory labeling ensures developers can't accidentally ignore error conditions. Every call to a throwing function requires deliberate acknowledgment of the error possibility.

### Enforced Error Handling

The Swift compiler won't allow you to ignore errors from throwing functions. You must handle them in one of these ways:

- Use a `do-catch` statement
- Propagate errors with `throws`
- Convert to optionals with `try?` (however this never actually reads the error)
- Force unwrap with `try!` (which should be used carefully)

This compiler enforcement prevents silent error situations that plague other languages.

### Consistency with Async/Await

Swift's error handling model aligns perfectly with its concurrency model:

```swift
func fetchLatestArticles() async throws -> [Article] {
    let (data, response) = try await URLSession.shared.data(from: articlesURL)
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw NetworkError.badResponse
    }
    return try JSONDecoder().decode([Article].self, from: data)
}
```

This consistency means the mental model you develop for one system applies to the other, simplifying the learning curve.

### Simple Error Propagation

Swift makes it easy to bubble up errors when appropriate:

```swift
func displayUserProfile(userId: String) throws {
    let user = try fetchUserData(userId: userId)
    let posts = try fetchUserPosts(for: user)
    let followers = try fetchUserFollowers(for: user)

    updateUI(with: user, posts: posts, followers: followers)
}
```

By marking the function with `throws`, you can seamlessly propagate errors to higher levels where they might be better handled.

## The Bad

Despite its strengths, Swift's error handling system has significant drawbacks that can lead to cumbersome code and subtle bugs.

### Value Scope Limitations within `do` Blocks

Perhaps the most frustrating limitation is that values created within a `do` block are trapped there:

```swift
do {
    let user = try fetchUserData(userId: "12345")
    // user is only available within this block
} catch {
    showErrorMessage(error)
}
// Can't access 'user' here!
```

This scope limitation forces developers to use awkward patterns like declaring variables before the `do` block or nesting all code that uses the value inside the `do` block, leading to deeply nested code.

### Overstuffed `do` Blocks

Because of the scope limitations, developers tend to put excessive amounts of code inside `do` blocks:

```swift
do {
    let user = try fetchUserData(userId: "12345")
    let posts = try fetchUserPosts(for: user)
    updateUserHeaderView(with: user)
    updateTimelineView(with: posts)
    trackAnalyticsEvent(.profileViewed)
    animateInProfileView()
    // Many more lines of non-throwing code...
} catch {
    showErrorMessage(error)
}
```

This approach mixes error-prone code with regular code, making the block's purpose unclear and hindering code organization.

### Multiple `try` Functions Create Ambiguity

When multiple throwing functions appear in the same `do` block, we encounter two critical problems:

#### Inability to Identify Which Function Threw

```swift
do {
    let user = try fetchUserData(userId: "12345")
    let posts = try fetchUserPosts(for: user)
    let followers = try fetchUserFollowers(for: user)
} catch {
    // Which operation failed? User fetch? Posts? Followers?
    // The catch block doesn't tell us. 
    showErrorMessage(error)
}
```

Unless you explicitly check the error type or use multiple `catch` clauses, you can't immediately know which operation failed.

####  Abrupt Control Flow Breaks

When an error occurs, execution immediately jumps to the `catch` block. This means all subsequent code in the `do` block is skipped:

```swift
do {
    startLoadingIndicator()
    let user = try fetchUserData(userId: "12345")
    let posts = try fetchUserPosts(for: user)
    stopLoadingIndicator() // This might never execute!
} catch {
    showErrorMessage(error)
    // We need to remember to stop the loading indicator here too
    stopLoadingIndicator()
}
```

This abrupt control flow makes cleanup code tricky and error-prone, especially for resource management.

To be clear, sometimes this is what we want. Oftentimes when there is an error, we do not want to continue executing the code because we could be making the situation even worse. We could put the program in an unresolvable state, or we could even corrupt the data forever. 

Nevertheless, this abrupt stop means that our code has far more possible paths than we might expect. In the above example, we have three possible paths:

1. The `do` block executes successfully
2. The `do` block throws an error after the first `try` statement and therefore the second `try` statement never executes
3. The `do` block throws an error after the second `try` statement and therefore both `try` statements executed. 

Every single `try` statement in the `do` block creates another possible path. 

### False Sense of Security

While Swift forces you to acknowledge errors, it doesn't force you to handle them meaningfully:

```swift
do {
    try veryComplexOperation()
} catch {
    // Catch everything but do nothing meaningful
    print("An error occurred: \(error)")
}
```

The compiler is satisfied with this implementation, but it doesn't ensure proper error recovery. There's no mechanism to ensure different error types receive appropriate handling.

## Typed Throws
With [SE-0413](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0413-typed-throws.md), Swift 6 introduces a new `typed throws` feature that allows you to specify the error type a function can throw. This change is a welcome addition to the language and even addresses many of the issues discussed above. However it really only mitigates the problem rather than solving it completely.

In fact, in the proposal itself, the authors actually recommend almost never using the new typed throws feature!

>Even with the introduction of typed throws into Swift, the existing (untyped) throws remains the better default error-handling mechanism for most Swift code.
>- [SE-0413](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0413-typed-throws.md#:~:text=Even%20with%20the%20introduction%20of%20typed%20throws%20into%20Swift%2C%20the%20existing%20(untyped)%20throws%20remains%20the%20better%20default%20error%2Dhandling%20mechanism%20for%20most%20Swift%20code.)

Isn't that strange? Why would you propose a new feature, and then immediately recommend that almost no one use it. Well, it turns out that this was the appropriate choice. Let's investigate below. 

### Type Systems: Static vs. Dynamic vs. Gradual
Swift is a statically typed language, and this comes with many benefits. For example, the compiler can prevent many common mistakes at compile time, infer types to write more concise code, and the compiler can optimize code automatically through the use of techniques like inlining. But Swift's error handling system is a special case that doesn't fit neatly into the type system.

The fundamental issue with Swift's error handling system is that throwing functions effectively have TWO return types:

1. The declared return type (when successful)
2. An error type (when failing)

This dual-return nature creates a unique control flow challenge. Unlike regular returns which follow a predictable path, thrown errors create an alternate exit point that:

1. Breaks the normal flow within the function itself (any code after the `throw` statement is skipped)
2. Breaks the normal flow within the caller's context (skipping to the `catch` block)

Furthermore, these two type systems behave differently and are in fact in completely different categories: 

1. The **declared return type** is a **static type**. 
2. The **error type** is: 
   1. A **dynamic type** (in Swift 5 and earlier)
   2. A **gradual type** (in Swift 6 and later)

What is a _gradual type_? Not long ago, [I wrote about the unique type system in GDScript]({{< ref "posts/post-25/Static Typing in GDScript.md" >}}). GDScript started out as a dynamic type system, much like Python. But over time, it has evolved to include static typing. As you can imagine, this could create a lot of problems. You can't just force everyone to use static typing, because that would break all the existing code. So instead GDScript has a system where you can use either static or dynamic typing on any variable or function. By default, GDScript uses dynamic typing, but if you explicitly declare a variable or function with a type, then it will use static typing. This is what we mean by [gradual typing](https://en.wikipedia.org/wiki/Gradual_typing).

This is effectively the same thing that happened with Swift 6's "second type system", the error type system. In Swift 5 and earlier the type system was a dynamic type system. But in Swift 6, we got the new ability to statically declare the error type. This is a gradual type system, because you can still use the old dynamic type system if you want to. The [Swift 6 Announcement](https://www.swift.org/blog/announcing-swift-6/#Typed-throws) states:

>Typed throws generalizes over throwing and non-throwing functions. A function that is specified as throws (without a specific error type) is equivalent to one that specifies `throws(any Error)`, whereas a non-throwing function is equivalent to one that specifies `throws(Never)`. Calls to functions that are `throws(Never)` are non-throwing and don’t require error handling at the call site.

For example: 

```swift
func typedThrowingFunction() throws(MyError) {}

func untypedThrowingFunction() throws {}
//                              👆🏼 this is a throws(any Error)
func nonThrowingFunction() {}
//                        👆🏼 this is a throws(Never)
```

Swift 6 can also interoperate with Swift 5 and earlier code. So you can call a Swift 6 function from Swift 5, even though Swift 5 has no concept of typed throws. Effectively what happens is Swift 5 will interprate any typed error as `throws(any Error)`. Swift 5 will happily call the Swift 6 function, and handle the error, but it won't know the error type at compile time. 

### How Typed Throws Mitigates the Problem
We mentioned earlier that the Error handling system can give you a false sense of security because the compiler will guarantee that every throwing function is caught, but it won't guarantee that every possible error is caught. Now with typed throws, we can make this guarantee. 

```swift
enum UserError: Error {
    case notFound(id: String)
    case invalidData
}

func fetchUserData(userId: String) throws(UserError) {
    guard let userData = database.fetchUser(withId: userId) else {
        throw UserError.notFound(id: userId)
    }
    return userData
}

func loadData() {
    do {
        let user = try fetchUserData(userId: "12345")
        updateUI(with: user)
    } catch { // remember that `catch` implicitly creates a variable called `error`

        // error has type UserError because fetchUserData has a typed throws. 
        switch error {
        case .notFound(let id):
            // Handle not found error
        case .invalidData:
            // Handle invalid data error
        @unknown default:
            // Log the error
        }
    }
}
```

Since we are using typed throws, now we know exactly what type of error we are dealing with. In Swift 5 `catch` would effectively give us an `error` variable of type `any Error`, but now in Swift 6, we have a concrete type. In this case, our `error` variable is of type `UserError` which is an `enum`. This means we can use a `switch` statement to handle each case of the error. We now have a compile-time guarantee that we are handling every possible error case. The function will only ever throw a `UserError`, and the `switch` will force us to handle every possible case! 

### Why Not Use Typed Throws Everywhere? 
You might be thinking, "Great! I can just use typed throws everywhere and solve all my problems!" I wouldn't blame you for thinking that. In Swift, we are very used to having a statically typed system, and enjoying all the benefits that come with that. But that static type system really only applies to the declared return type. The error type is a different story.

The error type is a gradual type. It is effectively dynamic by default, but we can opt into static error typing. Naturally, the question is: "Why don't we opt into static error typing everywhere?" The answer is that it is not always appropriate. While static typing is a fantastic fit for return types, it can be problematic for error types, for reasons we'll explore in a bit. But first, we have one more question to answer:

### What Happens When We Have Multiple Error Types? 
Back to our earlier example. We strongly typed our error, which means that now `catch` gives us a concrete error type. This fixes unresolved errors problem (if you recall, that's the problem where the compiler forces us to catch every problem, but does not force us to consider every possible error case). 

However, it doesn't fix the scope problem. We still cannot access the `user` variable outside of the `do` block. This is why we're forced to put `updateUI(with: user)` inside the `do` block, even though it doesn't throw. Because of that, this solution is basically unusable in most situations. For example, what happens if the `do` block contains `try` functions that throw different types of errors? 

```swift
enum MyError: Error { case error }
func typedThrows() throws(MyError) {
  throw .error
}
func untypedThrows() throws {
  throw MyError.error
}
enum MyOtherError: Error { case otherError }
func otherTypedThrows() throws(MyOtherError) {
  throw .otherError
}

func foo() {
  do {
    try typedThrows()
    try untypedThrows()
    try otherTypedThrows()
  } catch {
    print("error: \(type(of: error))") // error: any Error

    switch error {
      case .error: print("case .error")
// 🔴 type 'any Error' has no member 'error'
    }
  }
}
```
The code above fails to compile. In this case, we have three different throwing functions, and they all throw different types of errors. The `catch` block will give us an `error` variable of type `any Error`, which means we no longer know the error type in advance, making it much harder, if not impossible to guarantee that we are handling every possible error case.

### Typed Throws Are An API Contract
Now we are in a place to begin to understand why the authors of SE-0413 recommend that we almost never use typed throws. By typing your throws, you are effectively promising, and making a compile-time guarantee that your function will only throw that specific type of error. This can be a very difficult promise to keep because you may need to add new error cases in the future. This is especially true if your throwing function implementation calls other throwing functions. By default, all of their errors will be propagated up through your function. This means that you not only need to guarantee that your function will only throw that specific type of error, but you also need to guarantee that all of the functions you call will only throw that specific type of error. This is a very difficult promise to keep. 

## Takeaway: do, try, catch is problematic
If there's one thing you can take away from this post, it's this: **`do` `catch` blocks with multiple `try` functions are problematic**. They implicitly create new code paths. They catch errors without actually informing you which function threw the error. They create a false sense of security, that all errors are handled. Finally, they have a strong tendency to balloon into even larger `do` blocks, which only further exacerbates the problem.

This is a problem that is not unique to Swift. Many languages have similar issues and even worse issues. For example, in JavaScript, any function can throw an error and simply never tell you that they sometimes throw errors. Swift's error handling system has elegant solutions to many of these problems, but unfortunately, `do` `catch` blocks are not up to the task.

## Conclusion
Swift's error handling system offers clear benefits: explicit function contracts, mandatory error acknowledgment, and straightforward error propagation. However, its implementation introduces significant challenges around scope, control flow, and practical error handling.

These issues stem from the fundamental design choice to make error handling a special case of control flow rather than a type-based approach. While this design has performance benefits and syntactic clarity, it creates practical problems in everyday development scenarios.

In our next post, "Swift Error Handling: The Solution," we will present concrete strategies for overcoming these limitations today, along with a preview of my "Catcher" library designed to simplify error handling. We'll also explore potential language changes that could fundamentally resolve these issues in future Swift versions.


