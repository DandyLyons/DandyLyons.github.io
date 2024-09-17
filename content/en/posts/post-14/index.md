---
date: 2024-09-17
title: Benchmarking in Swift with swift-collections-benchmark
slug: benchmarking-in-swift-with-swift-collections-benchmark
description: 
tags: Swift, Benchmarking, "Data Structures and Algorithms"
---

# Benchmarking in Swift with `swift-collections-benchmark`

There is an age-old adage of programming which states *"Make it work, then make it right, then make it fast."* Today we will be focusing on how to *make it fast*, with the help of a valuable technique called Benchmarking. 

When developing software, especially when working with algorithms and data structures, performance is often a key concern. You may have experienced a piece of code that behaves well in your tests, but when it's exposed to real-world data, performance degrades. This is where **benchmarking** comes in. Benchmarking allows developers to measure how long a piece of code takes to run, helping to identify bottlenecks and areas for optimization.

In this post, we'll explore benchmarking in Swift using the `swift-collections-benchmark` package, comparing it with unit testing, snapshot testing, and performance testing. Then, we'll walk through an example comparing the performance of using an `Array` and a `Set` in Swift.

>It's important to note that Swift.org recently announced a new [Benchmark Package](https://www.swift.org/blog/benchmarks/). Perhaps that will be the more "modern" approach going forward. 

## What is Benchmarking?

Benchmarking measures the performance of a specific piece of code under controlled conditions. It’s not just about whether your code works, but how efficiently it works, particularly when operating on larger datasets. 

Benchmarking is somewhat analogous to **snapshot testing**, but for performance. Snapshot tests capture the output of a UI component and verify that it hasn't changed. Similarly, Benchmark tests capture the performance characteristics of your code and help ensure that performance doesn't degrade over time. It also helps identify areas where performance could be improved.

### Comparison to Other Testing Types

- **Unit Testing**: This checks if a small, isolated piece of code produces the correct result. It’s focused on correct behavior rather than performance.
- **Snapshot Testing**: This captures a "snapshot" of how a piece of code (often UI code) looks or behaves at a point in time, and tests future runs against that snapshot to detect changes. Again, it’s about correctness but not performance.
- **Performance Testing**: This is about analyzing the exact speed or memory usage. 
- **Benchmark Testing**: 
  - Like **Performance Testing**, Benchmark Testing analyzes speed and memory usage.[^2] 
  - And like **Snapshot Testing**, Benchmark Testing compares performance results to prior tests or established baselines in order to identify performance improvements or regressions as the codebase evolves over time. 

[^2]: Benchmark Testing is actually a subset of Performance Testing, not a separate category. 


| What We're Testing    | Single Test (Focus on Individual Case) | Comparison Against Prior Runs (Regression) |
| --------------- | -------------------------------------- | ------------------------------------------ |
| **Behavior** | Unit Testing                           | Snapshot Testing                           |
| **Performance** | Performance Testing                    | Benchmark Testing                          |

[^1]

[^1]: I'm certain that there are subtle nuances to this table which are missing. The purpose of this table is not to be perfectly academically accurate. The purpose is to compare Benchmark Testing to other forms of testing, which engineers are likely already familiar with, so that they can orient themselves, and understand the purpose of Benchmark Testing. 


## Benchmarking with `swift-collections-benchmark`

In 2021, Swift.org announced [Swift Collections](https://www.swift.org/blog/swift-collections/), an open-sourced package with more advanced data structures than those provided by the standard library. In order to develop Swift Collections, they developed [swift-collections-benchmark](https://github.com/apple/swift-collections-benchmark). This package is a great tool for benchmarking in Swift, particularly for comparing collections and algorithms. It provides a flexible framework for running performance tests and collecting detailed data on how different implementations behave under various conditions.

To show how this works, let’s dive into a simple example comparing two common collection types in Swift: `Array` and `Set`. Remember that an `Array` is an ordered `Collection` of values. A `Set` is similar to an `Array` but with two major differences: it is unordered, and it cannot contain duplicate values. Let's find out which has better performance...

## Example: Array vs Set Performance

### Problem Setup

Suppose we want to decide if we should use an `Array` or a `Set`. We're currently using an `Array` but we suspect a `Set might be faster. Let's test the performance of both across our use cases to see which is faster. 

### Benchmarking the Performance

To benchmark these two implementations, we’ll use the `swift-collections-benchmark` package to compare how long each function takes to execute.

#### Install the `swift-collections-benchmark` Package

If you haven't already, add the `swift-collections-benchmark` package to your project. You can do this via Swift Package Manager by adding the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-collections-benchmark", from: "1.0.0"),
]
```

Next, lets add the dependency to our target in our Package.swift file: 
```swift
.target(
      name: "MyBenchmark",
      dependencies: [
        .product(name: "CollectionsBenchmark", package: "swift-collections-benchmark"),
      ]),
```

#### Write a Benchmark Test

Here’s how we can use the `swift-collections-benchmark` framework to compare the performance of `containsInArray` and `containsInSet`:

```swift
import CollectionsBenchmark

// Create a benchmark test suite
var benchmark = Benchmark(title: "ArrayVsSet Benchmark")

// Add your tests here
benchmark.addSimple(
    title: "Array<Int> init",
    input: Int.self // 👈🏼 input type
) { input in
    blackHole(Array(0..<input))
}

benchmark.addSimple(
    title: "Set<Int> init",
    input: Int.self
) { input in
    blackHole(Set(0..<input)) // 👈🏼 What's blackhole? Read on and find out.
}

// Run your benchmark tests
benchmark.main()
```

In this benchmark, we add two tests, one for checking how long it takes to initialize an Array, and one for a Set. Notice how tell the framework the type of input we'll put into this test. CollectionsBenchmark will create randomized input to try running the same test repeatedly at different sizes. Types like `Int.self` and `[Int].self` are already built into the framework. If you want to use a custom type, you'll need to register a custom generator using the `registerInputGenerator` method on `Benchmark`. 

### Run the Benchmark Test

Remember that our target is an `executableTarget`. This is because CollectionsBenchmark is designed to be run from the command line. Here's an example of how to run it: 

```zsh
swift run -c release ArrayVsSetBenchmark run --cycles 3 results
```

Let's break it down: 
- `swift`: We'll use the Swift CLI to build and run the target. 
- `run`: We will run the target (which requires building)
- `-c release`: It is important to run benchmark tests in a release build. Why? See below...
- `ArrayVsSetBenchmark`: the name of the executable target as defined in our SPM package
- `run`: This second `run` is telling BenchmarkCollections to run the benchmark. To see other commands, try using `help`. 
- `--cycles 3`: We will rerun the benchmark test 3 times to get more data, and calculate averages. 
- `results`: Output the benchmark results into a JSON file named `results` in the same directory.

The command will output detailed results, including execution time, standard deviation, and number of iterations for each test case.

For more detailed documentation on setting up and running benchmarks, visit the official [`swift-collections-benchmark` documentation](https://github.com/apple/swift-collections-benchmark/blob/main/Documentation/01%20Getting%20Started.md).

#### Why It’s Important to Benchmark in Release Configuration

Benchmarking in **release** configuration is crucial because Swift optimizes code differently in debug and release configurations. In **debug** configuration, the compiler prioritizes features like code readability and easier debugging, which results in slower execution due to the absence of key optimizations. However, in **release** configuration, the compiler applies aggressive optimizations such as inlining, dead code elimination, and loop unrolling to improve performance. As a general rule **debug** configuration leads to faster compilation, but slower runtime, while **release** has slower compilation and faster runtime. To accurately measure how your code will behave in a real-world environment, always benchmark in release mode to ensure you're evaluating the fully optimized version of your code.

That being said, if your benchmark fails to run, you may need to run it in **debug** so that you can fix the problem. BenchmarkCollections will provide more helpful information if you run in **debug**. 

### What is `blackhole()`
You might have noticed a strange blackhole in our tests above: 

```swift
blackHole(Set(0..<input))
```

In swift-collections-benchmark, a black hole is used to prevent the Swift compiler's optimizer from removing what it might consider "unused" code during benchmarks. When measuring performance, if the optimizer detects that the results of an operation aren't being used, it might skip those operations entirely, leading to inaccurate benchmarks. A black hole function consumes the result of a computation in such a way that it can't be optimized away, ensuring the benchmark measures the actual execution time of the operations being tested. This guarantees the integrity and accuracy of performance measurements.

### Analyze the Results

When you run the benchmark, you should see output like the following:

```
Running 8 tasks on 76 sizes from 1 to 1M:
  Array<Int> init
  Set<Int> init
  Array<Int> append
  Array<Int> insert at 0
  Set<Int> insert
  Array<Int> removeLast
  Array<Int> removeFirst
  Set<Int> remove
Output file: /Users/daniellyons/Developer/My Swift Packages/ArrayVsSet/results
Appending to existing data (if any) for these tasks/sizes.

Collecting data:
  1.2.4...8...16...32...64...128...256...512...1k...2k...4k...8k...16k...32k...64k...128k...256k...512k...1M -- 40.5s
  1.2.4...8...16...32...64...128...256...512...1k...2k...4k...8k...16k...32k...64k...128k...256k...512k...1M -- 39.6s
  1.2.4...8...16...32...64...128...256...512...1k...2k...4k...8k...16k...32k...64k...128k...256k...512k...1M -- 40.8s
Finished in 121s
```

Just like the console says, there should be a new file named `results` with the results of the benchmark tests. If we open the file, we can see that it's a JSON file. This file will also be persisted across tests, so that you can compare current results to past results. This empowers you to catch performance regressions. Now, let's render these results into a format that is more useful. 

```zsh
swift run -c release ArrayVsSetBenchmark render results chart.png
```

Using the `render` command from `CollectionsBenchmark` we now have a new `chart.png` file that can visually show us our results. It should look something like this: 

![A line chart showing the performance differences between an `Array` and a `Set`.](<chart.png>)

On the x axis we can see the count of how many operations were performed by the framework. They increase exponentially as you move to the right. On the y axis we see the amount of time it took for those operations to be performed. They also increase exponentially as you move from the bottom to the top. Great! So what does all this mean? 

As you can see the performance characteristics of a `Set` and an `Array` are extremely similar. In fact, they are so similar that you probably don't need to care about the performance differences between them. The majority of the lines on the graph are roughly flat. With this scale, that means that they are operating at an O(n) complexity. 

But there are two very big exceptions: "Array<Int> removeFirst" and "Array<Int> insert at 0". Both of these tests have a noticeably steeper slope. Given the steepness of the slope it appears that they are running at O(n) time complexity. In other words, the increase in time is directly proportional to the amount of items in the operation. If we look at the documentation for these two methods, we will see that they are in fact expected to run at O(n) time complexity.[^3]

[^3]: Strangely, it seems that `array.insert(num, at: 0)` actually performs faster than the other insertion methods until we reach about 2,000 items. Then it performs exponentially slower. 

From our analysis, we should be able to learn this: An `Array` and a `Set` have remarkably similar performance except for some key use cases. If your use cases is one of those use cases, and particularly if you are dealing with large data sets, you should perhaps consider switching from an `Array` to a `Set`. 

## Conclusion

Benchmarking is an essential tool for ensuring that your code not only works, but works efficiently. While unit tests ensure correctness, benchmarking ensures performance remains consistent as your code evolves. Using the `swift-collections-benchmark` package makes it easy to measure and compare the performance of different implementations, as we demonstrated with the `Array` vs `Set` example.

By adding benchmark tests to your development workflow, you can catch potential performance regressions early and make data-driven decisions about how to optimize your code. If you would like to see the rest of the code I used to make this article to see [ArrayVsSet](https://github.com/DandyLyons/ArrayVsSet) on GitHub.

Have any questions? See any mistakes or areas that I could improve this article? Please message me on [Mastodon](https://iosdev.space/@dandylyons). 