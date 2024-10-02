---
date: 2024-10-01
title: Differentiating Parameterized Tests in Swift Testing
slug: differentiating-parameterized-tests-in-swift-testing
images: [""]
description: 
topics: ["Swift Testing"]
---
# Differentiating Parameterized Tests in Swift Testing
Swift Testing is a fantastic addition to the Swift ecosystem. They are concise and easy to understand. Parameterized tests are one of the best features of Swift Testing, but sometimes the framework needs a bit more information in order to work properly. Let's dig in. 

## What Are Parameterized Tests?
Parameterized tests are a feature that makes it easy to reuse testing logic across multiple cases of data. To see why that would be valuable let's look at Swift Testing's predecessor, XCTest.

### What's the Problem? 
XCTest and other testing frameworks make it difficult to reuse testing code. Because of this, many test suites are filled with tests that are essentially identical. This increases the burden of maintaining and updating tests.

```swift
import XCTest 

func validateEmail(_ string: String) -> Bool {
    // Check if the string is empty or too short to be a valid email
    guard string.count >= 3 else { return false }
    
    // Check if '@' exists and is not at the beginning or end
    guard let atIndex = string.firstIndex(of: "@"),
          atIndex != string.startIndex,
          atIndex != string.index(before: string.endIndex) else {
        return false
    }
    
    // Split the string into parts before and after '@'
    let beforeAt = string[..<atIndex]
    let afterAt = string[string.index(after: atIndex)...]
    
    // Check if there are characters before '@' and a domain after '@'
    return !beforeAt.isEmpty && afterAt.contains(".")
}

class EmailValidationTests: XCTestCase {
    func testValidate_helloEmail() {
        let input = "hello@email.com"
        XCTAssertTrue(validateEmail(input))
    }

    func testValidate_nameDotEmail() {
        let input = "first.second@web.com"
        XCTAssertTrue(validateEmail(input))
    }
}
```

In the tests above, there is virtually no difference in the logic between `testValidate_helloEmail()` and `testValidate_nameDotEmail()`. The only difference is the string that is being tested. We want to be able to test many different strings in order to test various edge cases, but each new string adds a significant amount of boilerplate code that needs to be maintained. 

Another option would be to combine multiple test cases into one like this. 
```swift
class EmailValidationTests: XCTestCase {
    func testValidateEmail() {
        let inputs = ["hello@email.com", "first.second@web.com", "DandyLyons"]
        for string in inputs {
            XCTAssertTrue(validateEmail(string))
        }
    }
}
```
However this approach isn't great either because when a test fails, we don't know which string caused it to fail.  In the code above, the first two strings pass, but the third string causes the entire test to fail, and we don't know which string caused the failure. To be fair, XCTest offers many other more robust ways to solve this problem, but Swift Testing has a solution that is very concise and ergonomic: **parameterized tests**.

### What's the Solution? 
In Swift Testing, we can define tests that accept parameters. We 

## Differentiating
### Differentiating Through `Equatable`

### Differentiating Through `Identifiable`

### Other Ways to Differentiate Tests

### `CustomTestArgumentEncodable`


---
## Further Exploration
