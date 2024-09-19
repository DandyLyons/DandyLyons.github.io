---
date: 2024-08-27
title: Demystifying Modern macOS Development
slug: demystifying-modern-macos-development
images: [""]
description: 
topics: [macOS, SwiftUI, Catalyst]
---

# Demystifying Modern macOS Development

## Introduction

For many years Apple, arguably left the mac to languish for years while it focused on iOS and the iPhone. The mac regularly got features years later than its mobile cousins, and the hardware was often behind and underpowered. But now, mac app development is currently in the best state that it has been in a very long time, thanks to three major developments: 

1. Apple released [Catalyst](https://developer.apple.com/mac-catalyst/), which translates iPad apps into native macOS apps. 
2. SwiftUI's _learn once, apply anywhere_ design has made it dramatically easier to share code between macOS and iOS 
3. Apple silicon allows us to run iOS apps natively on the mac without even translating. 

The good news is that we've never had so many powerful, first-party supported ways to develop mac apps. The not so good news is that it's never been so confusing. Today we will dive into the subtle differences between each of these approaches. 



## Terminology
Let's briefly revisit some terms so that we can understand some of the differences between each of these approaches. 

- **Devices**: For now, let's just focus on iPhone, iPad, and mac
- **OS**: These are the operating systems. For now let's focus on **iOS** and **macOS**. 
- **UI Framework**: For a long time, there were basically two frameworks to be concerned with: 
  - **AppKit**: for macOS and macs
  - **UIKit**: for iOS and iPhones and iPads[^2] 
- **SDK**: Software Developer Kit. These are the tools that we use to build our apps. 
- **Architecture**: Some of these devices have processors that are so different that the software in incompatible with each other. The software must be specifically compiled for the correct architecture. In our current context, there's really just 2 architectures that we are concerned with: 
  - Intel x86: Older macs that run on Intel processors
  - Apple Silicon: newer macs, and basically all of Apple's mobile devices. 
- **UI/UX Paradigms**: We would love to have a solution that can automatically port our code from one platform to another, but this is only solving half the problem. Macs and iPads are not only different devices and OS's

But as we'll see, things started to get more complicated...

[^2]: In 2019, Apple split iPadOS into its own operating system starting with iPadOS 13. However, this difference is more of a marketing difference than anything else. iPadOS is effectively the same OS as iOS, just running on an iPad, and in fact, in your actual code you will check for `iOS`, not for iPadOS. So in order to reduce complexity, in this article we'll just refer to iOS and that will mean both iPhone and iPad.

## Cross Platform Confusion
For many years, AppKit was effectively the only option available to write mac apps. Some of AppKit's API's are verbose and don't feel very "modern". But don't let that fool you. AppKit is a very full-featured, robust framework. It is extremely, flexible and powerful. Unfortunately, it is very difficult to make cross-platform apps with AppKit. If you're going to put all that effort into creating an app, wouldn't you want it to be available on as many platforms as possible? Today's customer's expect apps to be ubiquitous. They expect to be able to find their favorite apps on practically any platform, and they expect each platform to be at full feature parity. This is quite difficult to achieve in AppKit, since most AppKit code cannot be easily ported to other platforms. 

## iPad Apps Translated to macOS Using Catalyst
Apple realized that there are far more iOS developers, than macOS developers, so they created **Catalyst** to port to macOS. Catalyst is specifically for porting **iPad** apps to **mac**. This means that the same iPad app can run on 2 OS's (macOS and iOS), at least 2 devices (iPad and mac), 2 architectures (Intel and Apple Silicon), in 2 different UI paradigms (touch-first and Desktop), but they are built with one SDK (iOS). 

## SwiftUI Apps Running Natively on macOS
In 2019, the same year that Apple announced Catalyst, they also announced SwiftUI. For a long time, macOS apps must be written in AppKit, and iOS apps must be written in UIKit, but now they could be written with the same framework: SwiftUI. This means much of the same code can be used on both platforms, but not everything. Many methods are only available on one platform or the other. This is way Apple rejects the idea _write once, run anywhere_ and instead describes SwiftUI as _learn once, apply anywhere_. Now this means that the same code[^3] can be run on basically **all of Apple's devices**[^4], basically **all of Apple's OS's**, 2 architectures (Intel and Apple Silicon), in **all of Apple's available UI paradigms** (touch, desktop, watch etc.) and you can choose which SDK you would like to build with. 

[^3]: or rather **almost** the same code
[^4]: iPhone, iPad, Apple Watch, mac, Apple TV, Vision Pro etc. 

## SDK vs. OS
For a long time the SDK essentially mapped one-to-one to the OS. Building on the iOS SDK created a target that could run on the iOS OS, and only the iOS OS. This is no longer the case. Now you can build a target for the macOS OS using either SDK. To demonstrate my point, open an Xcode project with a multiplatform target. Click the project in the left sidebar. Now select the target. Now select the "General" tab, and view the "Supported Destinations" section. As you can see in the picture below there are multiple Mac destinations and they have different SDKs. 

![](<target-destinations.png>)

| Destination             | SDK   |
| ----------------------- | ----- |
| Mac                     | macOS |
| Mac (Mac Catalyst)      | iOS   |
| Mac (Designed for iPad) | iOS   |

The SDK is very important because it determines which types, methods, etc. your code has access to. 

```swift
struct JobCopilotApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  var body: some Scene {
    WindowGroup {
      App_V(store: self.appDelegate.store)
    }
    #if os(macOS)
    .onChange(of: true, initial: true) {
      print("On Mac (Designed for iPad) this doesn't run.")
      print("On Mac (Catalyst) I don't think this will run")
    }
    #endif
  }
}
```

## Compared Side-by Side

| **Aspect**                 | **Native macOS App (SwiftUI)** | **UIKit App on macOS (Catalyst)**                      | **SwiftUI Mac App (Designed for iPad)**                            |
| -------------------------- | ------------------------------ | ------------------------------------------------------ | ------------------------------------------------------------------ |
| **Operating System**       | macOS                          | macOS (via Catalyst)                                   | macOS (iPad app running on macOS)                                  |
| **SDK Used**               | macOS SDK                      | iOS SDK with Catalyst support                          | iOS SDK                                                            |
| **Primary Framework**      | SwiftUI (with possible AppKit) | UIKit (with Catalyst)[^1]                              | SwiftUI                                                            |
| **Target Device**          | Mac (desktop)                  | Mac (originally iPad)                                  | Mac (originally iPad)                                              |
| **Platform-Specific APIs** | Full access to macOS APIs      | Limited macOS API access via Catalyst                  | Limited macOS API access                                           |
| **Device Input Method**    | Mouse/Trackpad, Keyboard       | Mouse/Trackpad, Keyboard (with some touch adaptations) | Mouse/Trackpad, Keyboard (designed for touch but adapted)          |
| **Use Case**               | Full-featured macOS apps       | Porting **existing** iPad apps to macOS                | Bringing iPad apps to macOS with minimal changes                   |
| **Environmental Checks**   | `#if os(macOS)`                | `#if targetEnvironment(macCatalyst)`                   | `#if os(macOS)` combined with `#if targetEnvironment(macCatalyst)` |

[^1]: It is also possible to convert an SwiftUI iOS app to macOS using Catalyst, however, this approach tends to be less common since it's usually easier to run the same SwiftUI code directly in a macOS app (with minor adjustments). 

## Conclusion

Choosing the right approach for developing a Mac app depends on your project requirements, target audience, and development resources. Whether you opt for a native SwiftUI app, leverage Catalyst, or port a SwiftUI app designed for iPad, understanding the strengths and challenges of each method is key to creating a successful Mac application.

What approach do you prefer for Mac app development? Share your thoughts and experiences in the comments below. For more insights into SwiftUI, Catalyst, and macOS development, check out the related resources linked below.
