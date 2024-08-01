---
title: Hawaiian Vocab
date: 2024-03-01
---

<a href="https://apps.apple.com/us/app/hawaiian-vocab/id6478062401">
  <img src="https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg" alt="Download on the App Store">
</a>

_Hawaiʻian Vocab_ is a thoughtfully designed dictionary for the native Hawaiʻian language. There are 1000 Hawaiʻian words with definitions, pronunciations and example sentences. 

## Tech Stack 
| Component    | Tech                              |
| ------------ | --------------------------------- |
| Platforms    | iOS, iPadOS                       |
| Architecture | TCA (The Composable Architecture) |
| UI           | SwiftUI                           |
| ORM          | GRDB                              |

## Behind the Scenes
I started building _Hawaiʻian Vocab_ when I saw that there were no modern Hawaiʻian dictionary apps on the App Store. All were either vastly out of date (not even supporting retina screens) or they were missing basic information about the language. After 3 years of studying Hawaiʻian in High School, I wanted to brush up on my vocabulary and 

### Getting the Data
My first challenge was to find a suitable data source. Initially, I hoped to pull from Wikipediaʻs free and open Wiktionary dataset. Unfortunately I discovered that their Hawaiʻian word data set is lacking and their data is notoriously unstructured and difficult to parse. 

Then I started to experiment with generating my own data using LLMʻs. First I created my own dictionary entries written in simple JSON, then I let the LLM create new entries for me. They were surprisingly up to this task, meanwhile, with my prior knowledge of Hawaiʻian, I was able to make the necessary corrections. 

Then I had a large JSON object. I then created a python script to read the JSON from disk and load them into a SQLite database of my design. I then added this SQLite database as a resource in my iOS project, which is read at startup and run by [GRDB](https://swiftpackageindex.com/groue/GRDB.swift). 

I chose GRDB because it is very testable and easy to use since itʻs powered entirely by Swift value types. This is made even better because of The Composable Architectures extensive testing tools. 