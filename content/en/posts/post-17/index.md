---
date: 2024-09-25
title: The Swift Ranges Cheatsheet
slug: swift-ranges-cheatsheet
images: [""]
description: Ranges in Swift exlained, plain and simple.
topics: [Swift, Ranges, Cheatsheet]
---
Ranges are fantastic for when we want to work with a range of sorted values that contain no duplicates. 

## Core Concepts:
- **Ranges** in Swift define a sequence of values between two bounds (lower and upper) and are widely used in loops, slicing collections, and pattern matching.
- There are different types of ranges that control whether the bounds are included or excluded.
- **Pattern Matching**: Ranges can be used in `switch` statements or `if` conditions to check if a value falls within a specific range.
- **Comparable**: Ranges must hold a `Comparable` type.
- Prefer ranges when you want to work with a **sequence of values** without storing the elements in memory, unlike an **array** that holds all its values.

## Range Types Side by Side:

| **Syntax**     | **Range Type**       | **Description**                                                         | **Lower Bound (✅/❌)**   | **Upper Bound (✅/❌)**   | **Includes Upper Bound (✅/❌)** |
| -------------- | ------------------- | ----------------------------------------------------------------------- | ------------------------ | ------------------------ | ------------------------------ |
| `a..<b`        | `Range`              | Half-open range; includes lower bound, excludes upper bound              | ✅                       | ✅                        | ❌                             |
| `a...b`        | `ClosedRange`        | Closed range; includes both lower and upper bounds                       | ✅                       | ✅                        | ✅                             |
| `a...`         | `PartialRangeFrom`   | Range with only a lower bound                                            | ✅                       | ❌                        | ❌                             |
| `...b`         | `PartialRangeThrough`| Range with only an upper bound, includes upper bound                     | ❌                       | ✅                        | ✅                             |
| `..<b`         | `PartialRangeUpTo`   | Range with only an upper bound, excludes upper bound                     | ❌                       | ✅                        | ❌                             |
| `...`          | `UnboundedRange`     | Range without any bounds                                                 | ❌                       | ❌                        | ❌                             |

## Common Use Cases:

### Iteration: 
```swift
for i in 0..<5 {
    print(i) // Outputs 0 to 4
}
```

### Pattern Matching: 
Ranges are great to use in `switch` or `if-case` conditions to check if a value lies in a range.[^1]
```swift
let number = 7
switch number {
    case 0..<5: print("0 to 4")
    case 5...10: print("5 to 10")
    default: print("Out of range")
}
```

[^1]: Notice how we need to use `default` instead of `case 18...` here. Swift `switch` is great because it requires us to handle every case, thus eliminating niche bugs. Unfortunately, Swift is not able to determine if we have handled every case. See: https://forums.swift.org/t/switch-on-int-with-exhaustive-cases-still-needs-default/49548 

### Slicing
By slicing a collection we can create a smaller "view" of that collection without actually needing to copy it. 

```swift
let numbers = [10, 20, 30, 40, 50, 60]

// Slice the array to get elements from index 1 to 3 (i.e., 20, 30, 40)
let slice = numbers[1..<4] // ArraySlice<Int>

print(slice) // Output: [20, 30, 40]
```

Make sure you read [Sundell's article](https://www.swiftbysundell.com/articles/slicing-swift-collections/) on slicing! 

## Benefits Over Arrays:
- **Memory Efficient**: Ranges don't store the values they represent, they just define the bounds.
- **Performance**: Faster when iterating over numbers or intervals since there's no need to allocate memory for an entire sequence.
- Use a **range** when you need to express a numeric interval without storing values in memory. 
  - Arrays should be used when the actual values need to be accessed or manipulated.

## Conclusion
Ranges are a core part of Swift, used for efficient iteration, pattern matching, and controlling bounds in a concise and readable way.