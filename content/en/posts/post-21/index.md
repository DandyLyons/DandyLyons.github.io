---
date: 2024-10-16
title: "Mastering Swift Assertions: Choosing the Right Tool for the Job"
slug: mastering-swift-assertions
images: [""]
description: Should you use assert(), precondition(), or maybe fatalError()? Let's learn how to decide. 
topics: ["Swift"]
---

# Swift Assertions: Choosing the Right Tool for the Job

As Swift developers, we have several assertion tools at our disposal. But how do we choose the right one for each situation? This blog post will explore the different types of assertions in Swift and provide a framework to help you decide which to use and when.

## What is an assertion? 
Essentially assertion is a way to check your program's state at runtime. If the program is behaving correctly (i.e. if its state matches your expectation) then the assertion will do nothing. But if it is not behaving correctly, then **the app will crash**. In other words, **assertions in Swift are a way to crash your program on purpose**. 

Why would you want to crash your program on purpose? There are actually several valuable reasons. If you are developing, then crashing your program can help you catch bugs earlier. But it's not a great user experience for users when a program crashes. So we typically don't want to crash in a production build. Still, believe it or not, oftentimes it is best to crash, even in a production build when an end user is using your program! Some bugs can corrupt data, meaning that your user could lose that data forever. While it may be frustrating for a user to experience a crashing app, it would be far worse for them to lose their data. It is especially important to prevent data corruption because it could lead to undefined behavior and even more data corruption. 

For this reason, Swift provides us with several tools: 

1. `assert()` and `assertionFailure()`
2. `precondition()` and `preconditionFailure()`
3. `fatalError()`

## Types of Assertions in Swift

### 1. `assert()` and `assertionFailure()`

`assert()` is used to check a condition that must be true for your code to continue execution. If the condition is false, the assertion triggers and the program terminates. But the program will only terminate if this was a debug build. If you build the same code for production then Swift will ignore the `assert()` and move on. 

```swift
/// Divides two integers.
///
/// - Parameters:
///   - a: The numerator.
///   - b: The denominator.
/// - Returns: The result of the division.
/// - Precondition: `b` must not be zero.
func divide(_ a: Int, by b: Int) -> Int {
    assert(b != 0, "Cannot divide by zero")
    return a / b
}
```

Use `assertionFailure()` is when you have already checked that this is an appropriate time to crash your app in a debug build. 

```swift
// Direction is defined in some other library that we don't own. 
enum Direction {
    case north, south, east, west
}

// OUR CODE 👇🏼
import DirectionLibrary

func opposite() -> Direction {
  switch self {
  case .north: return .south
  case .south: return .north
  case .east: return .west
  case .west: return .east
  @unknown default:
      assertionFailure("Unknown direction")
      return .north
  }
}
```

In the above example the `switch` requires us to handle every possible case. But since `Direction` is from an external library, they could provide new cases in the future. This should never happen, but Swift still requires us to handle those cases just in case. So we add `@unknown default`. But how do we handle those cases, since we don't know what they are? We can't. So instead, we call `assertionFailure()`. This way if that case ever happens we will be notified in development by a failure. But in production, the assertion failure will be ignored and a dummy value will be sent instead. 

### 2. `precondition()` and `preconditionFailure()`

These function similarly to `assert()` and `assertionFailure()`, but they **remain active in release builds**. Use these if a problem could lead to undefined, unpredictable behavior or memory corruption. By crashing, you can prevent these worse problems. Plus, your user will be able to send you a crash report which you can then use to patch the bug. 

```swift
/// Calculates the square root of a number.
///
/// - Parameter x: The number to calculate the square root of.
/// - Returns: The square root of `x`.
/// - Precondition: `x` must be non-negative.
func sqrt(_ x: Double) -> Double {
    precondition(x >= 0, "`sqrt(_:)` is only defined for non-negative numbers")
    // implementation here
}
```

The precondition also forms a contract with the caller of this function. It essentially says "Do not call this function unless you have already checked for this precondition. Notice how, in the example above, we document that `x` must be non-negative when calling this function. 

### 3. `fatalError()`

`fatalError()` unconditionally terminates program execution and is always active, even in release builds. This is a very big hammer, so we don't want to use it unless we have no other choice. 

```swift
class Animal {
    /// Makes the sound of the animal.
    ///
    /// - Important: This method must be overridden by subclasses.
    /// - Note: Calling this method on `Animal` directly will cause a fatal error.
    func makeSound() {
        fatalError("This method must be overridden")
    }
}
```

Sometimes a class will implement a function with a fatalError if they require subclasses to override it. Another common use case is to fatal error when the app is unable to load the database upon startup. This is a very common pattern when using Core Data for example. 

## Crashes vs. Errors

Of course, it bears repeating that we should never crash unless we have exhausted our other options. If there is a problem in your program, consider if it would be better to throw an [Error](https://developer.apple.com/documentation/swift/error). In Swift, errors are intended to be recoverable. In other words, if it is possible to recover from the problem then consider throwing an error. But if the problem produces results that are so bad that they could send your program into undefined behavior, or corrupt data, then you should consider crashing. 

## Choosing the Right Tool

Here's a summary table to help you choose the right assertion:

| Assertion Type | Debug Build | Release Build | Use Case |
|----------------|-------------|---------------|----------|
| `assert()` | Active | Inactive | Debugging checks |
| `assertionFailure()` | Active | Inactive | Debugging failure points |
| `precondition()` | Active | Active | Critical checks, API contracts |
| `preconditionFailure()` | Active | Active | Critical failure points |
| `fatalError()` | Active | Active | Unrecoverable errors, required overrides |

- In debug builds, all assertions are active, helping catch errors early. 
- In release builds, `assert()` and `assertionFailure()` become no-ops, while `precondition()`, `preconditionFailure()`, and `fatalError()` remain active. 
- Use `assert()` for debugging, `precondition()` for critical checks that should always run (like API contracts), and `fatalError()` for truly unrecoverable situations or to mark methods that must be overridden.

Remember, the goal is to catch errors as early as possible while ensuring that your app behaves appropriately in production. Choose your assertions wisely to strike the right balance between robustness and user experience.

## Test Failures Instead of Crashes
`assert()` is powerful because it can help us catch bugs in development, before we ship. But a crash can still be cumbersome to deal with. Is there another approach? What if we could trigger a test failure instead of a crash? 

This is the approach of one of my favorite libraries [Swift Issue Reporting](https://swiftpackageindex.com/pointfreeco/swift-issue-reporting). The library includes a function called `reportIssue()`. It behaves much like `assert()` but much more intelligently. 

If you're app is currently running in a test, then `reportIssue()` will trigger a test failure. This means you can put `reportIssue()` anywhere you want in your actual app (not just test code)! If any test runs that code, then the test will fail. Even better, when running the app in the Xcode debugger it will trigger a helpful purple runtime warning. This will highlight the exact line that reported the issue. It can even be configured to trigger breakpoints, preconditions, or fatal error!

There are many, many more helpful features, so make sure you check out their documentation yourself. 

>Note: Swift Issue Reporting is currently going through a renaming transition. It used to be named "XCTestDynamicOverlay". So it's important to be aware of that so that you don't get confused by older documentation or URL's. Unfortunately Swift Package Manager sometimes gets confused when resolving package manifests in certain situations. 

## Consider Crashing

Today we learned the value of crashing. We also learned how, why and when to crash in Swift. The next time you are writing new functionality, don't just consider the happy path. Consider your failure cases, and ask yourself if you should crash. 


## Recommended Reading

- Swift Documentation
  - [Addressing crashes from Swift runtime errors](https://developer.apple.com/documentation/xcode/addressing-crashes-from-swift-runtime-errors)
  - [Analyzing a crash report](https://developer.apple.com/documentation/xcode/analyzing-a-crash-report)
  - [Error Handling](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling/)
- [SwiftRocks - How To Solve Any iOS Crash Ever](https://swiftrocks.com/how-to-solve-any-ios-crash-ever)
- [SwiftLee - EXC_BAD_ACCESS crash error: Understanding and solving it](https://www.avanderlee.com/swift/exc-bad-access-crash/)