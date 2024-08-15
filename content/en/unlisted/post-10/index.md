---
date: 2024-08-15
title: Exhaustive Testing Made Easy
images: [""]
description: 
tags: TCA, Swift, Testing
---

Testing is vitally important in virtually any tech stack. That is, unless you want to [shut down 8.5 million computers worldwide](https://en.wikipedia.org/wiki/2024_CrowdStrike_incident). [^1] Testing is more than a tedious chore. It's an automated warning system of current bugs. What is not automated (at least not entirely) is writing the tests. It takes time to write tests, and we have to know what needs to be tested. No matter how well your tests are written, if your tests don't cover a particular situation, then it won't be caught. This means that we need to assert on every value in our code. This is tedious and error-prone.

[^1]: Ok, that jab is not quite fair. Crowdstrike, did have testing, but clearly it wasn't very good. 

What if I told you there was a way to test all of your values exhaustively? Today we'll talk about "Exhaustive Testing" and as an added bonus, we'll talk about how to restore exhaustive testing when we have lost `Equatable` conformance. 

## The Problem With Non-Exhaustive Testing
Here's a trivial example. Suppose, you had a `Person` class like this:
```swift
class Person {
  var name: String?
  var hasName: Bool {
    name != ""
  }
  init(name: String) {
    self.name = name
  }
}
```
You realize that there is some hidden behavior here. `hasName` is effectively a function that calculates if the `Person` has a name. We need to test if this computed variable produces the correct result: 
```swift
func testPersonHasName() {
    let person = Person(name: "Blob")
    XCTAssertEqual(person.hasName, true) // ✅ test passed
}
```
Hooray! The test passed! Nope. This is a bad test, and it gives a false sense of security. If we add just a little more to our test, we'll find the bug. 
```swift
func testPersonHasName() {
    let person = Person(name: "Blob")
    XCTAssertEqual(person.hasName, true) // ✅ test passed
    person.name = nil
    XCTAssertEqual(person.hasName, false) // 🔴 test failed
}
```
`name` is now `nil`, so we should expect `hasName` to be `false`. It's not, and now we have a failing test proving that we have a bug in our code. We forgot to check for `nil`. But don't forget, **we only have this failing test because we remembered to test this case**.

The problem with non-exhaustive testing is [unknown unknowns](https://en.wikipedia.org/wiki/There_are_unknown_unknowns). You simply do not, and cannot know, what you do not know. The answer to this problem is simple[^4]: more tests. Let's test as much as we can so that we don't miss anything. But that leaves us less time to develop new features, and in some cases may even give us a false sense of security. 

[^4]: but not easy

## The Value of Exhaustive Testing
In principle, **Exhaustive Testing** means testing **every** part of your code exhaustively. This way you have to explicitly predict the exact state of your code so that you can prove that it behaves reliably. You might be thinking, "Well, that sounds... exhausting." It's actually not. In fact, it often results in shorter, simpler tests.

Now let's imagine if our `Person` class grew to something a little more complex. 
```swift
public class Person {
  var name: String?
  var birthPlace: Location
  public struct Location {
    var country: String
    var city: String
    var address: String
  }
  
  var contact: Contact
  public struct Contact {
    var phone: String
    var email: String
    var address: String
  }
  
  
  var hasName: Bool {
    name != "" && name != nil
  }
  // ...
}
```
Now, this is much more laborious to test, if we use the same strategy. We would have to assert on the value of each and every property in the type. We'd even have to assert on the value of the nested types. In practice, what will actually happen is we'll focus "important" stuff and leave the edge cases untested. 

## Implementing Exhaustive Testing
Now let's try testing with an exhaustive approach. One way to test exhaustively is to assert on the entire value of the `Person`. 
```swift 
XCTAssertEqual(person1, person2)
```
This is better, but there are two problems to this approach. First, `XCTAssertEqual` requires that the types be `Equatable`. For structs this is usually not very hard. We just conform our type to `Equatable` and Swift will automatically write the implementation for us, most of the time.[^2] For classes, you have to write the implementation yourself, and it's actually a lot more complex than it may seem. 

[^2]: Of course, Swift can only automatically synthesize `Equatable` conformance for structs if, you yourself have the the type definition, and all of it's nested properties, are also `Equatable`. 

But there's another approach that is faster, easier, and safer. The Swift standard library comes with a very helpful function called [dump](https://developer.apple.com/documentation/swift/dump(_:name:indent:maxdepth:maxitems:)). `dump` will print an entire type, and all of it's nested properties to the console. 

```swift
dump(person)
//Person #0
//▿ name: Optional("Blob")
//- some: "Blob"
//▿ birthPlace: Person.Location
//- country: "Some Country"
//- city: "Some City"
//- address: "Some Address"
//▿ contact: Person.Contact
//- phone: "Some Phone Number"
//- email: "Some Email"
//- address: "Some Address"
```

But even better, we can provide a text output stream to `dump`. In other words, we provide it a `String` to write to. Now we can easily write a test like this, and assert on the value of every single nested property, and we didn't even need to conform to `Equatable`! 

```swift
let person1 = Person(/*...*/)
let person2 = Person(/*...*/)
var person1String = ""
var person2String = ""
dump(person1, to: &person1String)
dump(person2, to: &person2String)
XCTAssertEqual(person1String, person2String)
```
I can't stress enough how revolutionary exhaustive testing is. If we used the property assertion method, we would need to tediously assert on every single nested property. If we remove or change a property, then now our test is broken. Even worse, if we add a property we need to remember to add the assertion to our test. If we forget, then the test will incorrectly pass, and we'll have false security.

On the other hand, things aren't much better with the equatable asertion method. The test is easier to write, but we've just shirked the responsibility to the `Equatable` conformance. If we had to manually conform to `Equatable` then we have the same problems. If we remove a property, then we break `Equatable`. If we add a property then we need to remember to add it to our `Equatable` conformance. Except now, if we forget to add it to `Equatable`, we not only get a false positive in our test, we also get incorrect behavior in our production code! 

Basically all these problems are gone with exhaustive testing, but we can make it even better. 

## Making Exhaustive Testing Ergonomic
[Pointfree](https://www.pointfree.co/) has created a fantastic library named [CustomDump](https://swiftpackageindex.com/pointfreeco/swift-custom-dump#user-content-expectnodifference), which takes the same concept as Swift's `dump` and adds some extra super powers. 

This library includes a very helpful method called [expectNoDifference](https://swiftpackageindex.com/pointfreeco/swift-custom-dump/main/documentation/customdump). `expectNoDifference` basically does the same thing that we did earlier in our dump assertion strategy, except even better.[^3] 
```swift
var person1 = Person(/*...*/)
person1.makeSomeMutation()
let person2 = Person(/*...*/)
expectNoDifference(person1, person2)
// Now we proof of every change that happened in `makeSomeMutation()`
```

[^3]: Though `expectNoDifference` does require your types to be `Equatable`.

![](<expectNoDifference.png>)

It is crazy how powerful and easy this method is! We now have deep testing on the entire hierarchy of of `Person` and when we have a failure, we even get a diff showing us exactly what changed. 



<!-- ## Bonus: How to Test in TCA Without Equatable
If you're intrigued by the idea of exhaustive testing then I strongly recommend you check out another fantastic library by Pointfree called [The Composable Architecture](https://swiftpackageindex.com/pointfreeco/swift-composable-architecture). TCA is a library and architecture for Apple platforms that comes with many benefits, including feature composition, scoped state management, and a robust dependency system. But it also has `CustomDump` and exhaustive testing built-in. 

Here's a very brief peek into what testing looks like in TCA: 

```swift
import ComposableArchitecture
let store = TestStore(initialState: Search.State()) {
  Search()
} 

// Send an action into your Store
await store.send(.searchFieldChanged("c") {
  // To pass, every single change in your State must be asserted here.
  $0.query = "c"
  $0.results = ["candy", "crab", "cream"]
}
``` -->

## Conclusion
Still I don't want to replace one false sense of security with another. Exhaustive testing is very valuable, but it is no silver bullet. The name is even a little misleading. It is exhaustive over every child property in a type, but it is not exhaustive over every function. Nor is it exhaustive over side effects from outside dependencies and so forth. My intention with this blog is not to claim that I've found a silver bullet to kill all bugs.

The point is to show that with exhaustive testing, we are exhaustively asserting on every value of every nested property. This is deep test coverage. We are testing issues that we likely would have never considered, and it turns out, it's actually easier to write as well. 