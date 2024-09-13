---
draft: true
date: 2024-09-17
title: Benchmarking in Swift with swift-collections-benchmark
slug: benchmarking-in-swift-with-swift-collections-benchmark
description: 
tags: Swift, Benchmarking, "Data Structures and Algorithms"
---

# Benchmarking in Swift with `swift-collections-benchmark`

There is an age-old adage of programming which states *"Make it work, then make it right, then make it fast."* Today we will be focusing on how to *make it fast*, with the help of a valuable tool called Benchmarking. 

When developing software, especially when working with algorithms and data structures, performance is often a key concern. You may have experienced a piece of code that behaves well in your tests, but when it's exposed to real-world data, performance degrades. This is where **benchmarking** comes in. Benchmarking allows developers to measure how long a piece of code takes to run, helping to identify bottlenecks and areas for optimization.

In this post, we'll explore benchmarking in Swift using the `swift-collections-benchmark` package, comparing it with unit testing, snapshot testing, and performance testing. Then, we'll walk through an example comparing the performance of using an `Array` and a `Set` in Swift.

>It's important to note that Swift.org recently announced a new [Benchmark Package](https://www.swift.org/blog/benchmarks/). Perhaps that will be the more "modern" approach going forward. 

## What is Benchmarking?

Benchmarking measures the performance of a specific piece of code under controlled conditions. It’s not just about whether your code works, but how efficiently it works, particularly when operating on larger datasets. 

Benchmarking is somewhat analogous to **snapshot testing**, but for performance. Snapshot tests capture the output of a UI component and verify that it hasn't changed. Similarly, Benchmark tests capture the performance characteristics of your code and help ensure that performance doesn't degrade over time. It also helps identify areas where performance could be improved.

### Comparison to Other Testing Types

- **Unit Testing**: This checks if a small, isolated piece of code produces the correct result. It’s focused on correctness rather than performance.
- **Snapshot Testing**: This captures a "snapshot" of how a piece of code (often UI code) looks or behaves at a point in time, and tests future runs against that snapshot to detect changes. Again, it’s about correctness but not performance.
- **Performance Testing**: This is about analyzing the exact speed or memory usage. 
- **Benchmark Testing**: 
  - Like **Performance Testing**, Benchmark Testing analyzes speed and memory usage.[^2] 
  - And like **Snapshot Testing**, Benchmark Testing compares performance results to prior tests or established baselines in order to identify performance improvements or regressions as the codebase evolves over time. 

[^2]: Benchmark Testing is actually a subset of Performance Testing, not a separate category. 


| Testing Type    | Single Test (Focus on Individual Case) | Comparison Against Prior Runs (Regression) |
| --------------- | -------------------------------------- | ------------------------------------------ |
| **Correctness** | Unit Testing                           | Snapshot Testing                           |
| **Performance** | Performance Testing                    | Benchmark Testing                          |

[^1]

[^1]: I'm certain that there are subtle nuances to this table which are missing. The purpose of this table is not to be perfectly academically accurate. The purpose is to compare Benchmark Testing to other forms of testing, which engineers are likely already familiar with, so that they can orient themselves, and understand the purpose of Benchmark Testing. 


## Benchmarking with `swift-collections-benchmark`

In 2021, Swift.org announced [Swift Collections](https://www.swift.org/blog/swift-collections/) an open-sourced package with more advanced data structures than those provided by the standard library. In order to develop Swift Collections, they developed [`swift-collections-benchmark`](https://github.com/apple/swift-collections-benchmark). This package is a great tool for benchmarking in Swift, particularly for comparing collections and algorithms. It provides a flexible framework for running performance tests and collecting detailed data on how different implementations behave under various conditions.

To show how this works, let’s dive into a simple example comparing two common collection types in Swift: `Array` and `Set`. Remember that an `Array` is an ordered `Collection` of values. A `Set` is similar to an `Array` but with two major differences: it is unordered, and it cannot contain duplicate values. Let's find out which has better performance...

## Example: Array vs Set Performance

### Problem Setup

Suppose we want to compare how long it takes to check whether a collection contains a specific element. We'll compare the performance of an `Array` and a `Set` when performing this lookup. 

### Step 1: Create anExample with an Array

```swift
let array = Array(1...1000000)

func containsInArray(_ value: Int) -> Bool {
    return array.contains(value)
}
```

In this example, we’re creating an array with 1,000,000 elements, and a simple function `containsInArray` that checks whether a given value is present in the array.

### Step 2: Create an Example with a Set

```swift
let set = Set(1...1000000)

func containsInSet(_ value: Int) -> Bool {
    return set.contains(value)
}
```

Similarly, we create a `Set` with 1,000,000 elements, and a function `containsInSet` that checks for the presence of a value.

### Step 3: Benchmarking the Performance

To benchmark these two implementations, we’ll use the `swift-collections-benchmark` package to compare how long each function takes to execute.

#### Install the `swift-collections-benchmark` Package

If you haven't already, add the `swift-collections-benchmark` package to your project. You can do this via Swift Package Manager by adding the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-collections-benchmark", from: "1.0.0"),
]
```

Then, import the package:

```swift
import CollectionsBenchmark
```

#### Step 4: Write a Benchmark Test

Here’s how we can use the `swift-collections-benchmark` framework to compare the performance of `containsInArray` and `containsInSet`:

```swift
import CollectionsBenchmark

let benchmark = Benchmark(title: "Array vs Set Contains Performance")

// Add the array test
benchmark.addSimple(
    title: "Array contains",
    input: Int.self
) { _ in
    _ = containsInArray(999999)
}

// Add the set test
benchmark.addSimple(
    title: "Set contains",
    input: Int.self
) { _ in
    _ = containsInSet(999999)
}

// Run the benchmark
benchmark.run()
```

In this benchmark, we add two tests—one for checking if an array contains the value `999,999`, and another for checking if a set contains the same value. Finally, we run the benchmark to see the results.

### Step 5: Run the Benchmark Test

Now you can run the tests directly from the command line. It's important to run the tests in **release mode** to ensure you're getting accurate performance measurements, as Swift applies optimizations in this mode that significantly affect performance.


Run the benchmark from the command line using the following command:

```bash
swift run -c release <benchmark-target>
```
 - `swift run` runs your project.
 - `-c release` ensures the benchmark is executed in **release mode** for accurate results.
 - `<benchmark-target>` refers to the target containing your benchmark code.

For example:
```bash
swift run -c release MyBenchmarkTarget
```

The command will output detailed results, including execution time, standard deviation, and number of iterations for each test case.

For more detailed documentation on setting up and running benchmarks, visit the official [`swift-collections-benchmark` documentation](https://github.com/apple/swift-collections-benchmark/blob/main/Documentation/01%20Getting%20Started.md).

#### Why It’s Important to Benchmark in Release Configuration

Benchmarking in **release** configuration is crucial because Swift optimizes code differently in debug and release configurations. In **debug** configuration, the compiler prioritizes features like code readability and easier debugging, which results in slower execution due to the absence of key optimizations. However, in **release** configuration, the compiler applies aggressive optimizations such as inlining, dead code elimination, and loop unrolling to improve performance.

If you benchmark in debug, you may end up with misleading results that don’t reflect the true performance of your code in production. To accurately measure how your code will behave in a real-world environment, always benchmark in release mode to ensure you're evaluating the fully optimized version of your code.

### Step 6: Analyze the Results

When you run the benchmark, you should see output like the following:

```
name                         time       std        iterations
-----------------------------------------------------------------
Array contains               250 μs     ± 20 μs    1000
Set contains                 10 μs      ±  1 μs    1000
```

In this case, you’ll likely notice that the `Set` performs significantly better than the `Array` for lookups. This is because `Set` is implemented as a hash table, which provides constant-time complexity (`O(1)`) for lookups, whereas `Array` performs a linear search (`O(n)`).

## Conclusion

Benchmarking is an essential tool for ensuring that your code not only works, but works efficiently. While unit tests ensure correctness, benchmarking ensures performance remains consistent as your code evolves. Using the `swift-collections-benchmark` package makes it easy to measure and compare the performance of different implementations, as we demonstrated with the `Array` vs `Set` example.

By adding benchmark tests to your development workflow, you can catch potential performance regressions early and make data-driven decisions about how to optimize your code.