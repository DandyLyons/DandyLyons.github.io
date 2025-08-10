---
date: 2025-08-10
title: "Why You Almost Certainly Should Not Be Using SwiftData or Core Data"
slug: 
images: []
description: 
topics: []
draft: true
---

It's always strange to me that developers will tell each other not to use certain tools and techniques. _Use SwiftUI, not AppKit. Use MVVM, not MVC._ Heck, developers will even say things like _Use tabs, not spaces._ Why should we care what someone **else** is using. If it works for them then why should I rain on their parade? If it doesn't work for them, then why is that my problem? 

...and yet here I am, trying telling you not to use something. 

Let me start by saying this, if you like SwiftData and/or Core Data, if it's working for you, then by all means keep using it. But hear me out, it's probably not as great as you think it is. 

## What is Core Data and SwiftData? 

## Reasons Not To Use Core Data
- SQLite got really good. 
  - There are great code examples of SQLite code everywhere. 
- Core Data is not open source. 
- Core Data has poor documentation. 
- Core Data is hiding important details from you. 
- Core Data is written in Objective-C: 
  - Core Data has a completely different meaning for Optional than Swift does: 
    - https://www.atomicbird.com/blog/clash-of-the-optionals/
- Core Data is only available on Apple platforms. 
  - You are limiting your reach to non-Apple devices. 
  - You are limiting your user's ability to sync to non-Apple devices. 
    - Your users want to be able to sync to web apps as well. 
