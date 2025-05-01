---
title: "Swift Error Handling: The Solution"
date: 2025-03-29
topics: ["Swift", "Error Handling"]
series: "Swift Error Handling"
image:
description: "Discover how a few simple methods can greately improve your error handling in Swift, to be safer and easier to understand."
slug: swift-error-handling-the-solution
---

# Swift Error Handling: The Solution
In our last post [Swift Error Handling: The Problem]({{< ref "posts/post-31/Swift Error Handling: The Problem.md">}}) , we discussed the problems with error handling in Swift. In this post, we will explore some solutions to these problems and how to implement them in your code, and we will preview my new [Catcher](https://swiftpackageindex.com/DandyLyons/Catcher) library which provides a variety of tools following these patterns. 

But alas, my library is not **the** solution. It is only **a** solution. In the last section, we will discuss some potential new Swift features that could eliminate these problems altogether.

## Recap of the Problem
First let's define the problem, so that we can define our requirements. If you recall the core problem with Swift's error handling system is that: 

1. `do` blocks with multiple `try` statements are problematic because: 
   1. When the function errors and jumps to the `catch` block, it is not clear which `try` statement caused the error.
   2. (Most of the time) the error is untyped, so you have to dynamically cast it to the correct type before you can read and handle it.
   3. The result of the `try` statement is not available outside of the `do` block, so in practice you end up putting more work in the `do` block (which only exacerbates the problem).
   4. Thrown errors abruptly exit the `do` block, which creates multiple code paths you have to consider.
2. Swift actually has TWO type systems: 
   1. The type system for the function signature including the return type. 
   2. The type system for the thrown error. 

## Designing the Requirements
Now that we have defined the problem, let's define our requirements for a solution.
1. We need a solution that doesn't require us to be in a throwing context. 
2. When we catch an error, there should be no ambiguity about which `try` statement caused the error.
3. We should be able to extract the result of the `try` statement outside of the `do` block.
4. It should be easy to handle the error meaning: 
   1. We should preserve the type of the error if it came from a typed throws function.

Ideally the solution should be built into the language, but alas, it is not. So we will have to implement it ourselves. But the Swift language has already natively fixed similar prblems in the past. With a little bit of elbow grease, we can repurpose some of these existing language features to solve our problem.

## Defining the Scenario
When designing a solution to a problem like this, I find that it is often helpful to define a very simple scenario to work with. This allows us to work on a specific small problem, and then we can generalize the solution to work with any problem in the future. 

```swift
enum MyError: Error, Sendable, Equatable {
    case error1
    case error2
}
func success() throws(MyError) -> Int {
    return 1
}
func failure1() throws(MyError) -> Int {
    throw MyError.error1
}
func failure2() throws(MyError) -> Int {
    throw MyError.error2
}
func mightThrow() throws(MyError) -> Int {
    if Bool.random() {
        return try success()
    } else {
        return try failure1()
    }
}
```

In this scenario we have a few throwing functions that returns an `Int` and throws a `MyError` error. What we really want and care about is the return result of the function. But sometimes we don't get a result at all. Sometimes the function exits before it has finished executing. So we need to handle that case as well. 

## Why We can't use `try?` or `try!` 
The common "Swifty" way to handle this is to use `try?` or `try!`. But these only partially solve the problem. 

```swift
func openInt() -> Int {
    guard let int = try? success() else {
       // handle error
       return
    }
}
```

This code is incredibly helpful and concise. It is doing so many things for us. It is:
1. Running the throwing function safely even though it is not in a throwing context like a `do` block.
2. Handling the error by converting the function result to an optional.
3. If the function succeds then the result is assigned to the `int` variable.
4. `int` is now available anywhere else. 
5. If the function throws an error, then we jump to the `else` block and we must exit the function.

It makes sense that this is such a popular method in the Swift community. It has a lot of benefits: 
1. It forces you to handle the situation where the function fails.
2. It's concise and fairly easy to understand.
3. The `int` variable is now available anywhere else in the function.
4. The `int` variable is now unwrapped, so you don't have to worry about it being `nil`.
5. There are only two code paths to consider: success and failure.

But it has one major problem. Do you see it? 

The problem is that we never get access to the error. We can't actually say that we handled the error. We did not handle the error. How could we have handled the error if we never even read it? We don't even know what the error was. We just ignored it. In the `else` block we know absolutely nothing about the error other than that it happened. We don't know what caused it, we don't know how to fix it, and we don't even know what the error was. Despite this massive problem, we can reuse these same tools to make a much better solution.

## From Two Type Systems to One
Remember that a throwing function effectively has two return types: 
1. The return type of the function.
2. The error type of the function.

But is there a way to combine these two types into one? Yes! In fact, it is already built into the language. 

## Converting Throwing Functions to Result Types
The `Result` type is a generic type that can be used to represent either a success or a failure. If you look at the open source code for the `Result` type, you will see that it is defined as follows: 

```swift
public enum Result<Success: ~Copyable & ~Escapable, Failure: Error> {
  /// A success, storing a `Success` value.
  case success(Success)

  /// A failure, storing a `Failure` value.
  case failure(Failure)
}
```

This type is extremely simple. We just have a simple enum with two cases: `success` and `failure`. The `success` case stores the result of the function, and the `failure` case stores the error, and the error must conform to the `Error` protocol. This is exactly what we need. We can use this type to represent the result of our throwing function.

At first, I thought to myself, we could just convert our throwing function into a `Result` type. I didn't realize that Swift already had this built-in as well. Let's look at my solution first. 

```swift 
public func result<Value>(
    for op: @autoclosure () throws -> Value
) -> Result<Value, any Error> {
    do {
        return Result.success(try op())
    } catch {
        return Result.failure(error)
    }
}
```

Here we have a function that takes a throwing function and returns a `Result` type. This gives us two benefits:
1. We do not need a throwing context to call this function (like a `do` block or a `throws` function).
2. We immediately get the result of the function and can use it anywhere else. It is not stuck in a `do` block.

Let's look at how to use this: 
```swift
func openInt() -> Int {
    let result = result(for: try success())
    switch result {
    case .success(let int):
        return int
    case .failure(let error):
        // handle error
        return 0
    }
}
```

Well, this isn't that much better. Our result may not be stuck in a `do` block, but it's still stuck in a `switch` statement. So we basically have the same problem. There is at least one benefit however. The Result type makes it easy for us to delegate the error handling to another function. And since `Result` is `Codable` it's easy to send over the network or persist to disk.

### The Built-in Solution
After getting some helpful feedback from the community, I learned that `Result` already has an initializer which conveniently takes a throwing function and returns a `Result` type. This is exactly what we need. 

```swift
let result = Result { try success() }
```
This is a much better solution. However, there is a small way that we can improve it. I'll make a new initializer that simply delegates the real implementation to the existing one. 

```swift
extension Result {
    public init(for op: @autoclosure () throws -> Success) {
        self = Result { try op() }
    }
}
// example usage
let result = Result(for: try success())
```

There is one small, but meaningful difference. I added an `@autoclosure` attribute to the function. This means that we can directly pass in the function without having to wrap it in a closure. But what I really care about is this: we can input one and only one `try` function. Remember that we are trying to solve the problem of having multiple `try` statements in a `do` block. The reason why we want to avoid having multiple `try` statements in a `do` block is because we don't know which one caused the error. But with this new initializer, we can only pass in one `try` statement. So we know exactly which one caused the error. We'll be reusing this pattern a lot. 

### Extracting a Value from a Result
It is worth mentioning that `Result` has a function called `get()` that will return the value of the `Result` type. This is fantastic! Except... `get()` is a throwing function. So we have to be in a throwing context to call it. We're basically right back where we started. 

This is not totally a loss however. We've discovered a way to convert a throwing function's two return types into one. While the `Result` type may not be the best choice in many use cases, it can still be quite helpful in some cases, for example if the best place to handle the error is on a different device over the network. 

Let's review our requirements and see how we did:
1. We need a solution that doesn't require us to be in a throwing context. 
   - ✅ We can conveniently convert to a `Result` type without being in a throwing context.
2. When we catch an error, there should be no ambiguity about which `try` statement caused the error.
   - ✅ The `@autoclosure` attribute forces us to pass in a single `try` statement.
3. We should be able to extract the result of the `try` statement outside of the `do` block.
   - 🤔 We sort of passed this. We can extract the result from the `Result` type, but we have to be in a throwing context to do so.
4. It should be easy to handle the error meaning:
   - ✅ We can use the `Result` type to preserve the type of the error.

Now, is there another way that we can convert a throwing function to a non-throwing function that will be more helpful? Yes!

## Converting Throwing Functions to Non-Throwing Functions
I did create a function that converts a throwing function to a non-throwing function, but as you'll see, it doesn't have that big of an advantage: 

```swift
public func doTry<E: Error>(
    _ op: @autoclosure () throws(E) -> Void,
    catching errorHandler: (E) -> Void
) {
    do {
        try op()
    } catch {
        errorHandler(error)
    }
}

// example usage
doTry(try mightThrow()) { (error: MyError) in
    // handle error
}
```
You might be thinking, "Wait a minute! This is just a `do` block with a `catch` statement!" And you would be right. Just like the last solution, the closure is an `@autoclosure` so we can only pass in one `try` statement. So when we catch the error, we know exactly which `try` statement (because there is only one). And if the function has a typed thrown error, then we even know the error type at compile time (just like a Swift 6 `catch` block). Unfortunately in my tests, it seems like Swift 6 is not able to infer the error type, so we have to explicitly declare the error type, which is a bummer. Hopefully that improves in the future. So, to recap, the only real advantage of this function is that it forces us to pass in a single `try` statement.

Let's keep searching for a better solution.

## Converting Throwing Functions to Optional Types
There's a very old problem that plagues virtually every programming language. It's the problem of having to check for `nil` values. In Swift, we have a very nice way of handling this with optionals. We can use optionals to represent a value that may or may not exist. The advantage is that Swift will force you to handle the case where the value is `nil`. 

### The "Trapped Scope" Problem
But there is another problem which plagues so many programming languages. I call it the "Trapped Scope" problem. This is when you "unwrap" a value but you are now in a different scope, so you can't use the unwrapped value in the old scope. You must somehow unwrap the value in the new scope, then safely pass it back to the old scope. For example: 

```swift
func add1(to int: Int?) -> Int? {
    if int == nil {
        return nil
    } else {
        return int! + 1
    }
}
```

This ugly code should trigger any Swift developer because the language has a built-in solution for this. But it can be helpful to not use the built-in solution to understand the problem. Here, we want to add 1 to an optional `Int`. But we have to check if the `Int` is `nil` first. If it is, we return `nil`. If it isn't, then we know that it is safe to use the `int` variable. Currently, this code is safe, but it is very easy to make a mistake. 

For example, we can safely force unwrap the `int` variable, but only inside of the `else` scope. In the `else` scope we know that the `int` variable is not `nil`, but in any other scope we don't know that. Thankfully, Swift has a built-in solution to this problem called `if let` which forces us to handle this correctly. 

```swift
func add1(to int: Int?) -> Int? {
    if let unwrappedInt = int {
        return unwrappedInt + 1
    } else {
        return nil
    }
}
```

Now the code is not only safe but Swift prevents us from using the `unwrappedInt` variable unless we are certain that it is not `nil`. For example, this will not compile: 

```swift
func add1(to int: Int?) -> Int? {
    if let unwrappedInt = int {
        return unwrappedInt + 1
    } else {
        return unwrappedInt + 1 
        // error: 'unwrappedInt' is not defined in this scope
    }
    // `unwrappedInt` is not defined here either
}
```

This is a great solution, but, for some use cases, it creates a new ergonomics problem: the "Trapped Scope" problem. This is when you "unwrap" a value but you are now in a different scope, so you can't use the unwrapped value in the old scope. But Swift has a clever solution for this problem as well, the `guard let` statement. We can rewrite the above like this: 

```swift
func add1(to int: Int?) -> Int? {
    guard let unwrappedInt = int else {
        return nil
    }
    // `unwrappedInt` is now available in this scope
    // and all scopes below this one

    return unwrappedInt + 1
}
```

This is the super power of `guard let`. It allows us to "unwrap" a value and use it in the same scope. This is a very powerful tool and we can even reuse this pattern to "unwrap" a throwing function. 

Recall that an `Optional` is just a simple enum like a `Result` type. It is defined like this: 

```swift
public enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}
```

This is extremely similar to the `Result` type. However, there is no associated value for the `none` case. What if we simply handled the error before converting to a `nil` value? Let's create a new initializer for the `Optional` type that takes a throwing function and returns an `Optional` type. 

```swift
extension Optional {
    public init<E: Error>(
        for op: @autoclosure () throws(E) -> Wrapped,
        catcher: (E) -> Void
    ) {
        do {
            self = try op()
        } catch {
            catcher(error)
            self = nil
        }
    }
}

// example usage
let optional = Optional(for: try success()) { (error: MyError) in
    // handle error
}
```
Now our throwing function is just a simple `Optional` type. We can use it just like any other optional. We don't need to worry error because it has already been handled. If there is an error, then the `catcher` closure will handle it, and the `Optional` variable will be `nil`. If there is no error, then the `Optional` variable will be `some` and we can use it just like any other optional.

```swift 
func getPostsFromAPI() -> [Post] {
    let maybePostsData: Data = Optional(for: try getPosts()) { (error: PostAPIError) in
        // handle error
    }
    guard let postsData = maybePostsData else { return [] }
    let maybePosts: [Post]? = Optional(
        for: try JSONDecoder().decode([Post].self, from: postsData),
        catcher: { error in
            // handle error
        }
    )
    guard let posts = maybePosts else { return [] }
    return posts
}
```

What have we accomplished?
1. We have a solution that doesn't require us to be in a throwing context.
2. When we catch an error, there is no ambiguity about which `try` statement caused the error.
3. We fixed the "Trapped Scope" problem by using `guard let` to unwrap the value.
4. When the error is statically typed, we can handle it confidently knowing that we have handled every possible case. 
5. When the error is untyped, at least we know exactly which `try` statement caused the error.

Let's compare this to the orthodox way of handling this. 

```swift
func getPostsFromAPI() -> [Post] {
    do {
        let postsData = try getPosts()
        let posts = try JSONDecoder().decode([Post].self, from: postsData)
        return posts
    } catch {
        // handle error
        return []
    }
}
```
This may look better. After all, it is less lines of code. But it is subtly worse for all the reasons we discussed in the last post. Namely the problem is that we have multiple `try` statements, but only one `catch` block. So we don't know which `try` statement caused the error. 

We also have the "Trapped Scope" problem, so if we'd like to do more processing on `postsData` or `posts`, we either have move that work into the `do` block, or copy it into a new variable outside of the `do` scope. 

## Converting Throwing Functions to Values
Hopefully, you are starting to see a pattern in these solutions. 
1. We take one and only one throwing function via an `@autoclosure` 
2. We handle the error in place
3. We return a new type

Let's look at how we can just straight up convert a throwing function into a value. First, let's look at the orthodox way of doing this: 

```swift
func getPostsFromAPI() -> [Post] {
    guard let postsData = try? getPosts(), 
          let posts = try? JSONDecoder().decode([Post].self, from: postsData) else {
        return []
    }
    return posts
}
```

This code looks simple and elegant, but it's even worse than the last example. Once again, we have multiple `try` statements, but only one `else` block. So we don't know which `try` statement caused the error. Even worse, we don't even know what the error was. We just ignored it and turned it into a `nil` value. How can we resolve the error if we never even read it? 

Remember this lesson: 
Sometimes code is short because it is elegant. 
Sometimes code is short because it is not actually doing its job.

For this reason, most Swift developers wouldn't use `guard let try?` unless they were absolutely sure that the function would never throw an error, or that any potential error was completely irrelevant. But more often than not, a Swift developer would use a `do` `catch` block here. Now let's try something new. 

```swift
public func value<Value, E: Error>(
    for op: @autoclosure () throws(E) -> Value,
    replaceTypedErrorWithValue onError: (E) -> Value
) -> Value {
    do {
        return try op()
    } catch {
        return onError(error)
    }
}

// example usage
let postsData: Data = value(
    for: try getPosts(),
    replaceTypedErrorWithValue: { error in
        // handle error
        // return a sensible default value
    }
)
let posts: [Post] = value(
    for: try JSONDecoder().decode([Post].self, from: postsData),
    replaceTypedErrorWithValue: { (error: PostAPIError) in
        // handle error
        // return a sensible default value
    }
)
```

Look at how much better this is! We have a function that takes a throwing function and returns a value. If the function throws an error, we can handle it in place and return a sensible default value. We always know exactly which `try` statement caused the error. 

---

## Future Swift Language Features
Now we have a solution that meets all of our requirements, but the truth is, I really hope that Swift sherlocks these solutions. Error handling is a core language problem and it should be built into the language. Over the years, many pitch proposals have attempted to tackle this issue, but none have been accepted yet. Here are two standout proposals that I think are worth mentioning:

### Last Expression As Return Value
This pitch suggests that the last expression should be treated as the return value in a variety of contexts including functions, and if or switch expressions.  One of the coolest things about this pitch is it would create `do` expressions. Here's the example from the pitch:

```swift
let icon: IconImage = do {
    let image = NSImage(
                    systemSymbolName: "something", 
                    accessibilityDescription: nil)!
    let preferredColor = NSColor(named: "AccentColor")!
    
    IconImage(
            image, 
            isSymbol: true, 
            isBackgroundSupressed: true, 
            preferredColor: preferredColor.cgColor)
}
```

This pitch have many benefits, but it would also have many far reaching implications. It's really not just about error handling. It's about many other issues as well. The pitch is quite in depth and I'm not gonna go deep on it here. You should read it [here](https://forums.swift.org/t/pitch-last-expression-as-return-value/76958).

### Guard Let Catch
This pitch suggests that we should be able to use `guard let` with a `catch` block. This would allow us to handle errors in a more concise way. Here's the example from the pitch:

```swift
func randomMovies(genre: Genre, count: Int) -> [Movie] {
   guard let movies = try Database.loadMovies(byGenre: genre)
   catch { return [] }

   guard !movies.isEmpty else { return [] }

   var randomMovies: [Movie] = []

   for _ in 0..<count {
      randomMovies.append(movies.randomElement()!)
   }
   
   return randomMovies
}
```

Personally, I love this pitch and I think it is the best solution that I've seen to handle this problem. It is simple, elegant, and easy to understand. It uses the same `guard let` syntax that we are already familiar with, and it allows us to handle errors immediately. And, of course, it also solves the "Trapped Scope" problem. Please read the full pitch [here](https://forums.swift.org/t/guard-let-catch-and-if-let-catch-to-avoid-long-nested-do-blocks/65827) and if you like it, please like and comment on it so that it gets more attention.

For some reason, this pitch has not gotten much attention. In fact, it has been practically dead for almost ten years when it was [pitched here](https://forums.swift.org/t/idea-extend-guard-to-try-statements-with-a-catch-block/1625/3) by none other than Swift creator Chris Lattner. I think this is a great solution and I would love to see it implemented in the language.

## Conclusion
In this post, we explored some solutions to the problems with error handling in Swift. We discussed how to convert throwing functions to non-throwing functions, how to handle errors in place, and how to use optionals to represent values that may or may not exist. We also looked at some future Swift language features that could help improve error handling in the language.

If you'd like to try out these solutions for yourself, please check out my [Catcher](https://swiftpackageindex.com/DandyLyons/Catcher) library. It is still in beta development, but it is open source and I would love to hear your feedback. Please report any issues you find, and let me know if you have any suggestions for improvements.