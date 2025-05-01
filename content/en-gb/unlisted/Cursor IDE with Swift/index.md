---
draft: true
date: 2024-09-17
title: Exploring AI Powered Swift Development in Cursor IDE
slug: exploring-ai-powered-swift-dev-in-cursor
description: Is Cursor IDE's Copilot a good fit for Swift development? 
topics: ["Cursor IDE", "Swift"]
---

# Exploring AI Powered Swift Development in Cursor IDE


## Myths About Swift Development
- You can only develop Swift in Xcode
- Swift in VS Code is bad/doesn't work

### Actual Limitations
- Only Xcode has the iOS SDK. 

## Why Use AI to Develop
- Ask questions about your code
- Write code faster

## Reasons to consider using Cursor
- Run AI off your device (unlike Xcode 16)
- The LLM has project wide context: 
  - `.cursorrules` file allows you to give project specific prompting
  - Type `@` symbol to add documentation to your prompts
- Cursor Composer: Multi-file editing. 

## About Cursor
- Cursor is a fork of VS Code. 
  - Cursor makes it ridiculously easy to switch from VS Code: 
    - It ports all your settings, keyboard shortcuts, and plugins.

## Setup
The setup for Cursor is basically identical to VS Code but with a few recommended extra steps. 

### Install the Swift Extension
Install the Swift Extension if you haven't done so already. 

### Index the Documentation in Cursor


### Add .cursorrules 
Each project in Cursor can optionally have a `.cursorrules` file. This is a file where you can put plain English instructions[^1]

[^1]: You can of course use other languages to provide prompts to the LLMs. In fact, that could be very helpful for your particular use case. However, the vast majority of the relevant text that these LLMs have been trained on is in English. In other words, you are likely to get better results if your prompts are in English. But fret not, even if English isn't your main language, LLMs are also very good at translation. Try prompts in your language first, and if the performance is sub-par, try translating your prompts into English to see if you get better results. 

## Conclusion: What is The Future of Software Engineering? 
