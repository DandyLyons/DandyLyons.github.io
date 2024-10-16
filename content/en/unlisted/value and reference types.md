---
date: 2024-10-15
title: "A Deep Dive into Value and Reference Types in Swift"
slug: 
images: [""]
description: 
topics: ["Swift"]
---
# A Deep Dive into Value and Reference Types in Swift

## The Value vs. Reference Problem
- Analogy: Library bookshelf
  - **Value type**: the book you want to read
  - **Reference type**: The Shelf where the book is located.

## How C Handles This Problem
https://www.w3schools.com/c/c_pointers.php



## How Swift Handles This Problem

### What Value and Reference Types Mean

- **Takeaway**: 
  - **Value Types**: `struct`, `enum`, and tuples. 
  - **Reference Types**: `class`, `actor` and closures.  

### What Value and Reference Semantics Mean

- ⭐: The distinction between value and reference **types** is a language-level feature (i.e. it's enforced by the compiler), but value and reference **semantics** is a language convention (i.e. not enforced by the compiler[^1]). 

[^1]: though it has been proposed [before](https://forums.swift.org/t/valuesemantic-protocol/41686)



