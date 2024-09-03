---
date: 2024-09-03
title: The Many Faces Of Swift's Regex
slug: the-many-faces-of-swifts-regex
# images: [""]
description: Learn how to take ad
tags: Regex, Swift
---

In Swift 5.7, Swift added native support for [regular expressions](https://en.wikipedia.org/wiki/Regular_expression) through a new type, [Regex](https://developer.apple.com/documentation/swift/regex). Regular expressions have been a staple part of programming for decades and provide many capabilities including: 

1. data detection
2. data validation
3. string parsing

<!-- >## To capture or not to capture?
>
>Brief aside, which will be important later: let's talk about the differences between detection, validation and parsing. **Detection** is finding if something is there (and where it is). For example, _is there a phone number in this string?_ **Validation** is determining if the string is a valid form of that data type. For example, _is 12-3456 a valid phone number?_ Finally, **parsing** is reading a string, and interpreting it as structured data. For example, _what is the area code, country code, and main part of the phone number?_ -->

However, regular expressions can also be notoriously difficult to use due to: 

1. a syntax that is extremely difficult to read 
2. every programming language has their own "flavor" of regular expressions which has its own subtle syntax and differences of capabilities

So thankfully Swift's native Regex holds some huge quality of life improvements including: 

1. compile-time type checking
2. an easier to read DSL
3. a literal syntax that is very similar to Perl, Python, Ruby and Java

Long story short, Swift's Regex makes regular expressions easier and safer to use, while not sacrificing on power. However, there's one issue left. There are many different methods to declare regular expressions. Each, offers its own set of tradeoffs, and each has slightly different syntax considerations. These differences can make it harder to understand regular expressions in different contexts. But if you understand each method, and their tradeoffs, then they can make working with regular expressions so much easier! 

## The Many Ways to Declare Strings
Strings? I thought we were talking about regular expressions. 

Yes, we are. But strings are intimately connected to regular expressions, and like `Regex` there are multiple ways to declare a String.

1. String literals
2. Raw string literal
3. String initializer

### String Literal
```swift
let string = "string"
let name = "Daniel"
let hello = "Hello \(name)" // Hello Daniel
let multilineString = """
This is a string
across
multiple lines.
"""
```
### Raw string literal
As you can see in the code above, [string interpolation](https://www.avanderlee.com/swift/string-interpolation/) allows us to input variables into our strings. To do this we must use `\` to escape our string. However there are some times when we want to be able to use characters like `\` and `"` in our strings. How do we do this? Enter raw strings: 
```swift
let rawString = #"This raw string can contain \ and " without escaping"#
let multilineRawString = #"""
This is a multiline 
raw string 
with \ and "
"""#
```
### String initializers
String is a struct, and so it can be initialized just like any other struct. 
```swift
let string = String("string")
```
You won't often need to use a `String` initializer directly, but it can be handy for some use cases. 

## The Many Ways to Declare Regular Expressions

Now that we have an overview of the many ways to declare `String`s, we can look at `Regex` and see the similarities.
Swift has many ways to declare regular expressions. Here are some of the most common: 

1. `NSRegularExpression`: the "legacy" option
2. `Regex` literals
3. `Regex` extended delimiter literals
4. `Regex` from runtime string
5. `Regex` from `RegexBuilder` DSL

### NSRegularExpression

This Foundation class dates all the way back to Objective-C and macOS 10.7. It is very powerful, and you will find a lot of code examples using it. However it was designed for Objective-C and therefore it's not very "swifty". For example, it uses `NSRange` instead of Swift's native `Range` type, which then means you can't use `Range` literals. In general, there isn't a reason to be using `NSRegularExpression`s today, now that we have `Regex`, but it is important to be aware of it so that you can understand legacy code. Here's an example: 

```swift 
import Foundation
// Declaration
let pattern = #"(\d{3})-(\d{3})-(\d{4})"#
let regex = try NSRegularExpression(pattern: pattern, options: [])
// Usage
let phoneNumberString = "Call me at 123-456-7890 or 987-654-3210"
let range = NSRange(phoneNumberString.startIndex..., in: phoneNumberString)
let containsPhoneNumber: Bool = regex.firstMatch(in: phoneNumberString, options: [], range: range) != nil
// containsPhoneNumber == true
```

>It's also worth mentioning `NSDataDetector` which is a subclass of `NSRegularExpression`. It has far more accurate capabilities for select data types including phone numbers and emails. NSHipster has a fantastic article about it [here](https://nshipster.com/nsdatadetector/). 

### Regex literals
Using `Regex` literals is simple. A literal simply starts and ends with a `/`, just like how a `String` literal starts and ends with `"`. Now, let's look at the legacy method above and see some of it's weaknesses so that we can better understand the problem that Swift's native `Regex` solves. 

Notice, the `NSRegularExpression` must be called with `try`. This is because you are passing in a string (`pattern`). The compiler has no way of knowing if this string is a valid regular expression, so it must check at runtime. In other words, if you forget a single character in that string, then the whole thing can break. Now let's look at the same thing with `Regex` literals: 

```swift
// Declaration
let regex = /(\d{3})-(\d{3})-(\d{4})/
// Usage 
let phoneNumberString = "Call me at 123-456-7890 or 987-654-3210"
let containsPhoneNumber: Bool = phoneNumberString.contains(regex)
// containsPhoneNumber == true
```
Aside from being shorter and easier to read, this code is also safer. Notice how as soon as you write it, the syntax is highlighted! The Swift compiler is checking that the `Regex` is valid at compile time! To prove my point, try deleting one of the `)` characters from the pattern string so that it looks like this: 

```swift
let pattern = #"(\d{3}-(\d{3})-(\d{4})"#
```
This is an easy mistake to make, yet this code will happily compile since it is a valid String. The problem won't arise until `NSRegularExpression` errors at runtime. Now try deleting the same character from the `Regex` literal: 

```swift
let regex = /(\d{3}-(\d{3})-(\d{4})/
// 🔴 error: cannot parse regular expression: expected ')'
```
Now we immediately get a compile error, and our syntax highlighting clues us into the problem!

### Regex extended delimiter literals
`Regex` literals can use a syntax which is very similar to raw strings: 

```swift
let rawString = #"raw\string"#
let regex = #/(\d{3})-(\d{3})-(\d{4})/#
```

The extended delimiter offers a few nice benefits: 
1. It will ignore whitespace so that we can structure our code in a more readable format. 
2. It allows for comments using `#`. 

So our phone number `Regex` can be rewritten like this: 

```swift
let regex = #/
(\d{3}) # Capture 3 digits
-       # Consume a "-"
(\d{3}) # Capture 3 digis
-       # Consume a "-"
(\d{4}) # Capture 4 digits
/#
```

### Regex from runtime string
Compile-time `Regex` is fantastic, but there are still times when runtime `Regex` could be preferable. For example, when we want to dynamically construct `Regex`s. 

```swift
var searchString: String // some user inputted string
let regex = try Regex(searchString)
let text = "hello world"
let containsSearchString = searchString.contains(regex)
// containsSearchString == true
```

Since the `Regex` initializer takes a simple `String`, we can dynamically create our regular expression pattern on the fly. This could be used to power a feature where a user would like to configure their search with tags and other features. 

### RegexBuilder DSL
Last, but certainly not least. Swift offers a powerful `Regex` DSL (domain-specific language) that is much easier to read and understand. Even better, we can easily convert a `Regex` literal into this DSL. (Note, to use this DSL, we must first import `RegexBuilder`) To do this, in Xcode, right-click any `Regex` literal, and select Refactor -> Convert to Regex Builder. If we do that to our phone number regex we'll get something like this. 

```swift
import RegexBuilder 

Regex {
  Capture {
    Repeat(count: 3) {
      One(.digit)
    }
  }
  "-"
  Capture {
    Repeat(count: 3) {
      One(.digit)
    }
  }
  "-"
  Capture {
    Repeat(count: 4) {
      One(.digit)
    }
  }
}
```
What if you're not using Xcode? Try using [SwiftRegex.com](https://www.swiftregex.com). It's a robust Regex playground and it will even convert to the Builder DSL. 

As you can see, the syntax is much more readable and it looks a lot like SwiftUI. This is because it's using the same Swift result builder language feature that powers SwiftUI. 

`RegexBuilder` can even be mixed and matched with literals. 

```swift
Regex {
  (\d{3})
  "-"
  (\d{3})
  "-"
  Capture {
    Repeat(count: 4) {
      One(.digit)
    }
  }
}
.anchorsMatchLineEndings()
```

#### Custom Regex Logic
You may be wondering _If I can automatically convert from Regex literal to RegexBuilder, can I convert back?_ Unfortunately no, and [this Swift Forum thread](https://forums.swift.org/t/any-way-to-get-raw-regex-literal-from-regexbuilder/58327) can give you more context on why. While it is a major bummer, there is actually a very good reason. The Swift Regex literal syntax is only a subset of the full Swift Regex engine. In other words, `RegexBuilder` can do even more than a `Regex` literal. 

In particular, `RegexBuilder` allows you to insert your own custom logic into your `RegexBuilder` using [CustomConsumingRegexComponent](https://developer.apple.com/documentation/swift/customconsumingregexcomponent). It also means that you can use Foundation to immediately adopt the complex parsing logic that Apple has been developing for decades! 

For more info, make sure you watch [WWDC22 - Swift Regex: Beyond the Basics](https://wwdcnotes.com/documentation/wwdcnotes/wwdc22-110358-swift-regex-beyond-the-basics/). 

## Picking the Right Tool for the Job
Swift's `Regex` type elegantly results in code that is safer and easier to read, while also adding more power! It also provides many different options of how to create `Regex`s. For reference we can look at the table below: 

| Method                              | Notes                                                                                       |
| ----------------------------------- | ------------------------------------------------------------------------------------------- |
| `Regex` literals                    | concise, but esoteric, same syntax as Perl, Python, Ruby, and Java, decades of example code |
| `Regex` extended delimiter literals | more readable                                                                               |
| `Regex` from runtime strings        | dynamic, no type checking                                                                   |
| `RegexBuilder` DSL                  | even more readable, but verbose                                                             |

I hope that this article has made Swift `Regex`, and regular expressions in general, more approachable. If you'd like to use `Regex` more, then please have a look at [NativeRegexExamples](https://swiftpackageindex.com/DandyLyons/NativeRegexExamples). I created this repository for crowd sourcing regular expression solutions from the Swift community. It includes a robust test suite of each `Regex` example. Together we can learn from each other and develop best practices! Please consider sharing and contributing. 