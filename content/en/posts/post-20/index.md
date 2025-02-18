---
date: 2024-10-08
title: "Exhaustive, Flexible, Multi-Typed Error Handling in Swift"
slug: typed-error-handling
images: ["exhaustive error handling.png"]
description: Learn how to get a compile-time guarantee that you have handled every possible error case! 
topics: ["Swift", "Swift 6", "Error Handling"]
---

Swift has long had fantastic error handling! Errors are simple value types that conform to the `Error` protocol. 

```swift
struct IceCreamShop {
   enum Error: Swift.Error {
        case notEnoughMoney
        case flavorNotSoldHere
   }
    
   private(set) var availableFlavors: [String: IceCreamFlavor]
   private(set) var cashOnHand: Int
   private(set) var isFreezerOn = true
   private(set) var billLastPaidOn: Date
   // ...
}
```

I really like this pattern! Here, we define a new error type that conforms to the `Error` protocol. The definition feels a little strange but the call site is very nice. Normally we would simply conform a type to `Error` but our type is also called `Error` so we have to disambiguate. We define an enum type named `Error` and it conforms to the `Swift.Error` protocol (the `Error` protocol from the Swift standard library). Why go to this trouble? Because the nested type makes the purpose very clear. In the outside world we can refer to the type as `IceCreamShop.Error`, and inside the type we can call it `Self.Error`. So it is very clear that `IceCreamShop.Error` is designed to contain all the possible errors of the `IceCreamShop` type. However, this is just a naming convention and nothing in the compiler enforces which types of errors can be thrown. 


## The Problem with Untyped Errors
This has been a bit of a pain point in Swift. Thankfully, we know exactly which functions can throw. We must handle every thrown error. We must mark every function that can throw with the keyword `throws` at the definition site, and with `try` at the call site. 

But how do we know what types of errors might be thrown? We have to do some digging in the documentation (if it even exists) and we have to hope that we didn't miss any error cases. 

```swift
do {
   try iceCreamShop.sellIceCream(flavorName: "Strawberry")
} catch {
   // what kind of errors should I expect???
}
```

## Typed throws in Swift 6
Swift 6 made this much nicer with typed errors. Now a function can declare in advance what types of errors it will throw. The compiler will enforce that the function is not allowed to throw any other Error types, meaning you can exhaustively handle all the error types without worrying if you missed any. We do this with a new type parameter that can be applied to the `throws` keyword. Now the compiler will guarantee that the function is only allowed to throw that type of function, and the caller can rest assured knowing that they've handled every case. 

```swift
func sellIceCream(flavorName: String) throws(Self.Error) {
   guard isFlavorSoldHere(flavorName) else { throw .flavorNotSoldHere }
   try availableFlavors[flavorName]?.scoop() // 🔴
   // Thrown expression type 'IceCreamFlavor.Error' cannot be converted to error type 'IceCreamShop.Error'

   cashOnHand += 1
   try payBillIfNecessary()
}
```

This is good because we can guarantee that the function will throw `IceCreamShop.Error` errors and only that type. Another nicety is that the compiler can infer the error type. Notice how we `throw .flavorNotSoldHere` instead of `throw Self.Error.flavorNotSoldHere`. 

Nevertheless, typed throws here can be fairly limiting. What if we need to handle error types that have been defined elsewhere? One approach is we could handle the outside error types here, but here might not be the best place to handle it. What if our callers want to handle those errors?  

Another approach is we could add outside error cases to our error type, then we can throw our own errors. 

```swift
struct IceCreamFlavor {
   enum Error: Swift.Error {
        case flavorOutOfStock
        case iceCreamMelted
    }
    // ...
}
struct IceCreamShop {
   enum Error: Swift.Error {
        case notEnoughMoney
        case flavorNotSoldHere

        // from IceCreamFlavor.Error
        case flavorOutOfStock
        case iceCreamMelted
   }

   // ...

   func sellIceCream(flavorName: String) throws(Self.Error) {
      guard isFlavorSoldHere(flavorName) else { throw Self.flavorNotSoldHere }
      do {
         try availableFlavors[flavorName]?.scoop()
      } catch let error as IceCreamShop.Error {
         switch error {
            case .flavorOutOfStock: throw Self.flavorOutOfStock
            case .iceCreamMelted: throw Self.iceCreamMelted
         }
      } catch {
            print("🚨 Unknown error not handled.")
      }

      cashOnHand += 1
      // ...
   }
}
```

I really would not recommend that we use this approach. For one, we now have duplicated code that needs to be kept in sync. We also have to maintain documentation to match someone else's types and documentation. Furthermore, the caller loses the original error type. They have to trust and rely on us to keep our types and documentation and types in sync with the other error types. 

What would be really nice is if there were a way to declare that we could throw multiple types. What if we could declare something like this? 

```swift
func sellIceCream(flavorName: String) throws(Self.Error & IceCreamFlavor.Error) {
   
}
```

Here we would be saying, my function can throw either a `Self.Error` (`IceCreamShop.Error`), or an `IceCreamFlavor.Error`. But alas, Swift does not allow us throw more than one type of error. But fret not, there is actually a better solution, using associated values on enums. 

## Multi-Typed Errors With Exhaustive Handling
Recall that an enum is a set of cases. But you can also attach an [associated value](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/enumerations/#Associated-Values) to as many or as few of those cases as you like. So we can effectively embed our `IceCreamFlavor.Error` into our `IceCreamShop.Error`. So we would transform this...

```swift
struct IceCreamShop {
   enum Error: Swift.Error {
        case notEnoughMoney
        case flavorNotSoldHere

        // from IceCreamFlavor.Error
        case flavorOutOfStock
        case iceCreamMelted
   }
   // ...
}
```

...into this: 

```swift 
struct IceCreamShop {
   enum Error: Swift.Error {
        case notEnoughMoney
        case flavorNotSoldHere

        case flavorError(IceCreamFlavor.Error)
   }
   // ...
}
```

Now we no longer need to keep our types and documentation in sync. It is made explicitly clear in the type system that we are wrapping a `IceCreamFlavor.Error` into an `IceCreamShop.Error` and we are passing the original error onto the caller. Now the caller can exhaustively handle all the error cases of our type, and the external type. 

```swift
do {
      try iceCreamShop.sellIceCream(flavorName: "Strawberry")
   } catch {
   switch error { // Swift knows that error is a `IceCreamShop.Error`
      case .flavorNotSoldHere:
            print("Sir, this is a Baskin Robbins.")
      case let .flavorError(flavorError):
            switch flavorError {
               case .flavorOutOfStock:
                  print("Shucks! We're out of that flavor.")
               case .iceCreamMelted:
                  print("...would you like a milk drink instead? 😅")
            }
      case .notEnoughMoney:
            print("Time for us to go out of business...")
      
   }
}
```

Recall that in Swift `switch` requires us to exhaustively handle every enum case. In fact, if we forget any cases, then Swift will through a compile-time error which is great. In the example above we used nested switch statements to guarantee that we are handling every case of `IceCreamShop.Error` **and** every case of `IceCreamFlavor.Error`. If we ever add a case to either error type, then these switch statements will warn us that there are new error cases that we need to handle! We have a compile-time guarantee that we have handled every possible error!

## One Large Caveat: structs
There is a large caveat to mention about this approach. While it is very common for errors in Swift to be designed as an enum, this is not the only way. Swift just requires our errors to be a **value type** that **conforms to the enum protocol**. In other words, errors can also be structs. That's a bit of a problem because a `switch` can exhaustively pattern match on enums, but not structs. In other words we lose that exhaustive checking for structs. But all is not lost. We wouldn't lost the exhaustivity for everything, just for the struct. And even then, we know that our error cases are confined to whatever that struct can produce. So if we added a struct case...

```swift
struct IceCreamShop {
   enum Error: Swift.Error {
        case notEnoughMoney
        case flavorNotSoldHere

        case flavorError(IceCreamFlavor.Error)
        case networkError(NetworkError)
   }
   // ...
}

struct NetworkError: Error {
   let statusCode: String
}
```
... we could still handle cases like this...

```swift
   do {
        try iceCreamShop.sellIceCream(flavorName: "Strawberry")
    } catch {
      switch error { // Swift knows that error is a `IceCreamShop.Error`
         case .flavorNotSoldHere:
            print("Sir, this is a Baskin Robbins.")
         case let .flavorError(flavorError):
            switch flavorError {
               case .flavorOutOfStock:
                  print("Shucks! We're out of that flavor.")
               case .iceCreamMelted:
                  print("...would you like a milk drink instead? 😅")
            }
         case .notEnoughMoney:
            print("Time for us to go out of business...")
         case let .networkError(networkError): 
            // handle network error here
         
      }
   }
```

It is true that we lost our ability to `switch` on the `NetworkError`, since it is a struct, but we did not lose exhaustive checking for the `IceCreamFlavor.Error`, nor for the rest of the `IceCreamShop.Error`. 

It's also worth noting that almost anything that can be expressed in a struct `Error` can also be expressed in an enum `Error`. If you're consuming someone else's `Error` type then you're kind of just stuck with whatever they give you. But if you are used to writing `Error`s as struct, try writing it as an enum instead. For example we could just as easily rewrite our `NetworkError` to look like this: 

```swift
enum NetworkError: Error {
   case statusCode(String)
}
```

## Untyped Errors in Swift 6
Swift has always been a strongly, statically typed language by default. But that's not the case when it comes to errors. Before Swift 6 error types were statically defined but never really enforced, meaning it was your job to find all the possible error types and handle them. So how do we transition from a non-typed error language to a typed-error language? Who knows how many throwing functions there are? Do we have to annotate types to all of our throwing functions? That sounds like a nightmare! Thankfully this is not the case. 

We can continue using the `throws` keyword just as we did before and it behaves exactly the same as before. While it isn't strictly necessary to understand how this works, it is helpful. 

```swift
func nonThrowingFunction() {
   //...
}

func throwingFunction() throws {
   //...
}
```

This is how we would have defined functions in a pre-Swift 6 world, and in fact this is probably the way that we will continue to define most functions in a post-Swift 6 world. But let's look at what Swift is actually inferring.

```swift
func nonThrowingFunction() throws(Never) {
   //...
}

func throwingFunction() throws(any Error) {
   //...
}
```

Both of these styles are equivalent in Swift 6. If you define a non-throwing function in Swift 6, it will infer it to be a `throws(Never)`. In practice, this doesn't really change anything. It's just kind of cool to know. But the next one is more important...

If you define a plain old throwing function, using `throws`, but you don't specify the type, then Swift 6 will infer it to be a `throws(any Error)` type. Recall that `Error` is a protocol, not a concrete type. Also recall that `any` behaves differently than `some`. 

`some` essentially says _"Swift, we know the type statically, at compile-time, but I don't want to figure it out. I just know it conforms to this protocol. Can you please figure out the actual type for me, please?"_ This is why we use `some` in SwiftUI. In the example below, `body` is a `Text` type. We know this at compile time.

```swift
struct MyView: View {
   var body: some View {
      Text("Hello world!")
   }
}
```

`any` says something very different than `some`. `any` says _"I don't know the type, but I do know the protocol."_ This part is just like `some`. But here's the part that's very different. `any` also says _"Hey Swift, I don't want you to figure out the type at compile time. In fact, I want to be able to dynamically change the concrete type whenver I feel like it. The only guarantee is it will always be a type that conforms to this protocol."_ 

For more info on `any` see the WWDC talk about it [here](https://developer.apple.com/videos/play/wwdc2022/110352/?time=1251). 

This is the way that pre-Swift 6 `throws` worked (and the way that it will continue to work post-Swift 6). `throwingFunction()` could throw `any Error`. The type system doesn't know ahead of time what the error type will be. The only thing it does know is that it will conform to `Error`. The formal name for this kind of type is called an *existential type*. Existential types are great because they give us more flexibility at runtime, but this flexibility is not free. 

>Throwing an instance of any Error or another boxed protocol type requires allocating memory at runtime to store the error. In contrast, throwing an error of a specific type lets Swift avoid heap allocation for errors.
>- [Swift.org](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling/#:~:text=Throwing%20an%20instance%20of%20any%20Error%20or%20another%20boxed%20protocol%20type%20requires%20allocating%20memory%20at%20runtime%20to%20store%20the%20error.%20In%20contrast%2C%20throwing%20an%20error%20of%20a%20specific%20type%20lets%20Swift%20avoid%20heap%20allocation%20for%20errors.)

Essentially any time you use an existential type, including any time that you use the `any` keyword[^1], this will require the compiler to store your type in a wrapper type that can find the underlying value at runtime. In other words, it uses more memory, and it requires slightly more compute. Most of the time, this is small enough to not matter, but there are cases when it very much matters. For example, if you are deploying to [Embedded Swift](https://www.swift.org/blog/embedded-swift-examples/) or [Swift on Wasm](https://swiftwasm.org/) then this dynamic runtime is not available. You essentially have to type all your errors in these constricted environments.

[^1]: and therefore anytime you use the `throws` keyword without specifying a type

Outside of those constricting environements, the performance benefits of typed throws is probably negligible. But the usability benefits can be considerable. It can be quite nice to have the comfort of knowing that you have a compile-time guarantee that you have exhaustively handled every possible error case. It's also nice to document your error cases in the type system. This way, even if we miss a detail in the docs, we know that the compiler has our backs. 

## Should You Use Typed Errors
Typed throws are probably one of my favorite new features in Swift 6, but understandably it's totally overshadowed by another set of features, strict concurrency checking. The other thing that is strange is that **it almost feels like the language team is actively discouraging us from using this shiny new toy**: 

>All of the examples above use the most common kind of error handling, where the errors that your code throws can be values of any type that conforms to the Error protocol. This approach matches the reality that you don’t know ahead of time every error that could happen while the code is running, especially when propagating errors thrown somewhere else. It also reflects the fact that errors can change over time. New versions of a library — including libraries that your dependencies use — can throw new errors, and the rich complexity of real-world user configurations can expose failure modes that weren’t visible during development or testing. The error handling code in the examples above always includes a default case to handle errors that don’t have a specific catch clause.
>[Swift.org](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling/#Specifying-the-Error-Type)

This paragraph has some good points. It is true that _"you don’t know ahead of time every error that could happen while the code is running"_, but part of me wonders if this is splitting hairs. Using the approach above, we are not guaranteeing that our code has no errors at all. That's just silly and its more of a philosophical statement than a meaningful statement in code. No, the above approach is guaranteeing that **we handled every error type that was explicitly declared by the library**. In other words, the library author declared _"Hey, watch out for these types of errors."_ by writing `throws(MyErrorType)` and we responded _"Thanks for the heads up!"_ in the `catch` block. 

The other thing that is baffling to me is that the docs recommend using the `default` case. In practice, I actively avoid using `default` whenever possible. As soon as you use `default`, you lose exhaustive checking. The convenience it adds is negligible, and the cost just isn't worth it. 

## Conclusion
Error handling has never been a substitute for testing, and that won't change with typed errors. But with typed errors, and the approach described above we can guarantee that we won't forget to catch error cases. **This approach certainly cannot be applied everywhere**, and indeed there are many situations where we have too many unknown variables to use this approach. But this approach can be used in some places, and wherever it is used, it can greatly improve ergonomics, readability and maintainability. Try using typed throws in small simple areas in your code base. Using the approach above, you can "bubble up" errors as high as you like, allowing you to gradually add more typed throws to your code base. 

I try to release new posts every week. If you liked this post (or even if you didn't like it) please give me some feedback on [Mastodon](https://iosdev.space/@dandylyons), [LinkedIn](https://www.linkedin.com/in/dandylyons/) etc. 

---
If you would like to see the full toy example of the ice cream shop, please check out the gist [here](https://gist.github.com/DandyLyons/ab101ecaa4d8a73c4202ed2cc8a0a12d).