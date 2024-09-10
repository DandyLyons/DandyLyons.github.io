---
date: 2024-09-10
title: Using Custom Components in Swift's Regex
slug: using-custom-components-in-swifts-regex
description: Plug your own custom logic into any Swift Regex!
tags: Regex, Swift
---

In our [last article]({{< ref "post-12" >}}) we learned about Swift's `Regex` type and the various different ways to create them. Today we're going to dive a little deeper into one of those methods. We'll be building a custom `RegexComponent` using the [CustomConsumingRegexComponent](https://developer.apple.com/documentation/swift/customconsumingregexcomponent) protocol. 

For a quick refresher, remember that we can create a custom parser using the `RegexBuilder` DSL like this: 

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

Don't forget that we can use many built-in parsers provided by `Foundation` like this: 

```swift
let usdRegex = Regex {
  Capture(.currency(code: "USD").sign(strategy: .accounting))
}

let dateRegex = Regex {
    Capture(
        .date(
            .numeric,
            locale: .autoupdatingCurrent,
            timeZone: .autoupdatingCurrent,
            calendar: .autoupdatingCurrent
        )
    )
}

let intRegex = Regex {
    Capture(.localizedInteger(locale: .autoupdatingCurrent))
}
```

## Using `NSDataDetector` Inside a Swift `Regex` 
Not only can you use `Foundation`'s parsers, you can also create your own custom parsers, through the [CustomConsumingRegexComponent](https://developer.apple.com/documentation/swift/customconsumingregexcomponent) protocol. Let's create a new custom parser that uses Apple's `NSDataDetector` class. 

First, let's get a working example of our `NSDataDetector` to detect phone numbers: 

```swift
import Foundation
import RegexBuilder

let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
let detector = try NSDataDetector(types: types.rawValue)
let input = "(808) 232-4825"
let swiftRange = input.startIndex..<input.endIndex
let nsRange = NSRange(swiftRange, in: input) // Fatal error: String index is out of bounds
var result: String?
detector.enumerateMatches(
    in: input,
    options: [],
    range: nsRange,
    using: { (match, flags, _) in
        guard let phoneNumber = match?.phoneNumber,
            let nsRange = match?.range,
            let swiftRange = Range.init(nsRange, in: input) else {
            print("no phone number found")
            result = nil
            return
        }
        print("found phone number: \(phoneNumber)")
        result = phoneNumber
    }
)
```

Conforming to `CustomConsumingRegexComponent` is fairly straightforward. We simply implement [consuming(_:startingAt:in:)](https://developer.apple.com/documentation/swift/customconsumingregexcomponent/consuming(_:startingat:in:)): 

```swift
public struct PhoneNumberDataDetector: CustomConsumingRegexComponent {
    public typealias RegexOutput = String
    public func consuming(
        _ input: String,
        startingAt index: String.Index,
        in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: String)? {
        // implementation goes here...
    }
}
```

## CustomConsumingRegexComponent
So now let's plug in our earlier implementation: 

```swift
public struct PhoneNumberDataDetector: CustomConsumingRegexComponent {
    public typealias RegexOutput = String
    public func consuming(
        _ input: String,
        startingAt index: String.Index,
        in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: String)? {
        var result: (upperBound: String.Index, output: String)?
        
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        let detector = try NSDataDetector(types: types.rawValue)
        let swiftRange = index..<input.endIndex
        let nsRange = NSRange(swiftRange, in: input) // Fatal error: String index is out of bounds
        detector.enumerateMatches(
            in: input,
            options: [],
            range: nsRange,
            using: { (match, flags, _) in
                guard let phoneNumber = match?.phoneNumber,
                      let nsRange = match?.range,
                      let swiftRange = Range(nsRange, in: input) else {
                    // no phone number found
                    result = nil; return
                }
                
                result = (upperBound: swiftRange.upperBound, output: phoneNumber)
            }
        )
        
        return result
    }
}
```

As you can see the `NSDataDetector` API is a bit cumbersome to use. Notice how we need to convert back and forth between `Range` and `NSRange`. As [Mattt from NSHipster said](https://nshipster.com/nsdatadetector/): "*NSDataDetector has an interface that only a mother could love.*" But now we have a new Swift interface that is far easier to use. Now that it is a `RegexComponent`, we can plug it into any `Regex` like this: 

```swift
let phoneNumberDataDetector: some RegexComponent = Regex {
    ChoiceOf {
        Anchor.startOfLine
        Anchor.startOfSubject
        One(.whitespace)
    }
    PhoneNumberDataDetector()
    ChoiceOf {
        Anchor.endOfLine
        Anchor.endOfSubject
        Anchor.endOfSubjectBeforeNewline
        One(.whitespace)
    }
}
```

_Note, however, that in Swift 6 language mode, we have Data Race Safety turned on. Unfortunately, `Regex` is not `Sendable` so we will need to isolate it somehow. One of the easiest ways to do this is to use a global actor._ 

```swift
@MainActor
let phoneNumberDataDetector: some RegexComponent = Regex {
    // ...
}
```

## Room For Improvement
Writing parsers is complicated. Even the most sophisticated parser can be overcome by an obscure corner case. But by converting our `NSDataDetector` into a `RegexComponent` we now get to take advantage of decades of Apple's development. Even better, our new detector is composable and can be added as a component to any other `RegexComponent`. 

Still, as great as this solution is, there is still room for improvement. In my testing, so far, I found many correctly parsed strings. "555-1234", "(808) 555-1234", "1 (808) 555-1234" were all correctly identified as phone numbers. However, I did have some false negatives (at least what would appear to be ). I would have expected "5555-1234" to NOT be identified as a phone number. Whatver solution you use, remember to test your code. Don't just test the happy path. Assert that your code does not generate **false-positives** or **false-negatives**. 

Another issue is, there seems to be a mistake with the bounds calculation for my implementation of this parser. Because of this, it can work effectively with methods like `wholeMatch()` or `contains()`. However, it works incorrectly with `replace()`. Instead of just replacing the matched phone number, it replaces the entire string. 

If you see any solutions, please don't hesitate to reach out to me on [Mastodon](https://iosdev.space/@dandylyons), or [X](https://x.com/dan_dee_lyons). 

## Think of the Possibilities
There are so many more powerful parsing libraries that could benefit from Swift's `Regex`. For example [Pointfree](https://www.pointfree.co/) has a powerful parsing library called [swift-parsing](https://swiftpackageindex.com/pointfreeco/swift-parsing#user-content-documentation). It has an API that looks a lot like RegexBuilders, and yet it's far more flexible. By creating a `CustomConsumingRegexComponent` we could allow any Regex to take advantage of the swift-parsing library. 

Do you have any code that you think could be super-powered as a RegexComponent? 

## Conclusion
When writing parsers, we have to fully appreciate the full domain of the problem that we are trying to solve. There are dozens of phone numbers. Perhaps hundreds of phone companies. Many of these are standardized, but there are certainly exceptions to all of these standards and there is no one universally accepted standard. The problem domain is far too large and ever-changing for one team to tackle. Instead we should look to battle-tested parsers established by the community to tackle these problems. 

That's why I created [NativeRegexExamples](https://swiftpackageindex.com/DandyLyons/NativeRegexExamples). It's a library where we can crowd-source our learning, and collectively discover best practices for various parsers. Please contribute, so that the entire community can benefit! 