---
title: "How to Teach LLMs to Tell Time: Tool Calling with Apple Foundation Models"
slug: teach-llms-to-tell-time
date: 2025-07-03T12:39:00.000Z
author: Daniel Lyons
tags:
  - programming
topics: ["AI", "LLMs", "Large Language Models", "Programming", "Apple Foundation Models", "Swift", "iOS Development"]
draft: true
description: Learn how to teach LLMs to tell time using tool calling. This article explores the challenges and solutions for integrating real-time data with large language models using Apple's FoundationModels framework.
---

In July 2024, Anthropic [revealed their system prompts to the public](https://docs.anthropic.com/en/release-notes/system-prompts). This taught the community [a ton of valuable insights about how to properly prompt engineer](https://simonwillison.net/2025/May/25/claude-4-system-prompt/). One interesting insight that we learned is that the prompt immediately tells the model what the current date is. This teaches us about a limitation of virtually all LLMs: they don't know how to tell time. It also shows us how to solve this problem: let's just tell them what the time is. 

## LLMs Can't Tell Time. Why is that such a big deal? 
LLMs rely on whatever is in their training data. Inevitably this will be out of date, especially with real-time knowledge like knowing the current date or time. 

Some tasks **require** the model to know the current time. For example, if the user asks *what's the weather like tomorrow?* 

## Why Is This Problem Hard? 
LLMs are inherently ill-suited to solve this problem. They can only output something that is in their training data, and it takes way too long to add info to training. We can't get real-time data this way.

Thankfully, getting real-time data is really easy. We have tons of APIs. 

The problem is that these real-time data systems require predictable inputs or they will simply fail. **The real problem is that we want predictable systems (APIs and other traditional software) to interact with non-predictable systems (Large Language Models).** 

| **Traditional Software** (Deterministic)                                          | **Modern AI** (LLMs, Diffusion etc.) (Non-Deterministic) |
| --------------------------------------------------------------------------------- | -------------------------------------------------------- |
| Requires **predictable inputs in a specific structure** or it will fail or error. | Can handle unpredictable unstructured inputs.            |
| Creates predictable, structured outputs.                                          | Creates unpredictable, unstructured outputs.             |

## How the Problem Got Solved
The FoundationModels framework comes with various tools to help solve this problem. 

### The `@Generable` Macro
This macro programmatically constrains the model to output data that matches your type. It also prompts the model and tells the model what kind of data you are looking for. 
```swift
@Generable
struct SearchSuggestions {
    @Guide(description: "A list of suggested search terms", .count(4))
    var searchTerms: [SearchTerm]


    @Generable
    struct SearchTerm {
        // Use a generation identifier for types the framework generates.
        var id: GenerationID


        @Guide(description: "A 2 or 3 word search term, like 'Beautiful sunsets'")
        var searchTerm: String
    }
}
```

#### The `@Guide` Macro
Provides extra guidance on what type of data should be in a property. You can provide extra prompting to tell the model info about the property. **You can programmatically constrain the results.**

### `Tool` Protocol
```swift
import FoundationModels
import Contacts

struct FindContactTool: Tool {
    let name = "findContact"
    let description = "Finds a contact from a specified age generation."

    @Generable
    struct Arguments {
        let generation: Generation
    }

    @Generable
    enum Generation {
        case babyBoomers
        case genX
        case millennial
        case genZ
    }
    
	func call(arguments: Arguments) async throws -> ToolOutput {
		let store = CNContactStore()
	
		let keysToFetch = [CNContactGivenNameKey, CNContactBirthdayKey] as [CNKeyDescriptor]
		let request = CNContactFetchRequest(keysToFetch: keysToFetch)
	
		var contacts: [CNContact] = []
		try store.enumerateContacts(with: request) { contact, stop in
			if let year = contact.birthday?.year {
				if arguments.generation.yearRange.contains(year) {
					contacts.append(contact)
				}
			}
		}
	
		guard let pickedContact = contacts.randomElement() else {
			return ToolOutput("Could not find a contact.")
		}
		return ToolOutput(pickedContact.givenName)
	}
}
```

### The `#Playground` Macro
This makes it really easy to try code directly in Xcode and see results in place. This is especially important when interacting with LLMs where the tiniest difference in text can result in very different behavior. 

## Building a Time Fetching Tool
Here is the tool I built to solve this problem: 

```swift
//
//  GetCurrentDateTool.swift
//  Agenta
//
//  Created by Daniel Lyons on 6/22/25.
//

import Foundation
import FoundationModels
import Playgrounds

struct GetDateTool: Tool {
    let name = "getCurrentDate"
    let description = "Reads the device's current date and time, or a date relative to now."
    
    @Generable
    struct Arguments {
        @Guide(description: "The kind of date to return. Now, before now, or after now.")
        let dateKind: DateKind
        
        @Generable
        enum DateKind {
            case now
            case beforeNow(seconds: Int) // unfortunately, there doesn't seem to be a way to apply a `@Guide` to an enum case
            case afterNow(seconds: Int)
        }
    }
    
    // A requirement of the `Tool` protocol.
    func call(arguments: Arguments) async throws -> ToolOutput {
        let date: Date
        switch arguments.dateKind {
        case .now:
            date = Date()
        case let .afterNow(seconds: secondsAfter):
            date = Date().addingTimeInterval(TimeInterval(secondsAfter))
        case let .beforeNow(seconds: secondsBefore):
            date = Date().addingTimeInterval(-TimeInterval(secondsBefore))
        }
        
        return ToolOutput(
            GeneratedContent(
                properties: [
                    "dateISO8601": date.iso8601WithCurrentTimeZone(),
                    "dateLocalized": date.localizedFull(),
                ]
            )
        )
    }
}

extension Date {
    /// return a standardized highly structured and machine-readable date
    func iso8601WithCurrentTimeZone() -> String {
        return self.ISO8601Format(.iso8601(timeZone: .current))
    }
    
    /// return a date that is more human-friendly and follows the user's locale and time zone preferences.
    func localizedFull() -> String {
        return self.formatted(.dateTime.weekday().year().month().day().hour().minute().second().locale(.current))
    }
}

#Playground {
    // example of prompting the model to use the get date tool. 
    let session = LanguageModelSession(
        tools: [GetDateTool()], // This adds information about the tool to the context window.
        instructions: "You can use tools to answer questions about the current date and time. e.g. 'What time is it?' or 'What day is it?'", // While we shouldn't need to explicitly tell the model to use these tools in the instructions (since we already told them in the `tools` parameter), it seems that Apple's model is strongly trained to tell the user that it CANNOT tell the time. To fix this problem, we remind the model yet again that it can use tools to answer questions about the current date and time.
    )
    _ = Date().iso8601WithCurrentTimeZone() // call this just to show the current value in the playground console
    _ = Date().localizedFull() // call this just to show the current value in the playground console
    do {
        try await session.respond(to: "What day is it?") // current date
        try await session.respond(to: "What day of the week is tomorrow?") // relative date
        try await session.respond(to: "What's the time? In hh:mm:ss format.") // dates with formatting
        try await session.respond(to: "Okay, now what time is it? Include seconds.") // subsequent prompts should cause the tool to be called again to get the latest date and time
        try await session.respond(to: "Use a tool to get the current date and time.") // While you shouldn't have to explicitly call the tool, sometimes it helps.
        try await session.respond(to: "What day of the month is it?")
        try await session.respond(to: "What time will it be two hours from now?")
        try await session.respond(to: "What day is next friday?")
    } catch let generationError as LanguageModelSession.GenerationError {
        dump(generationError) // send the entire error structure to the playground for inspecting
    } catch let toolCallError as LanguageModelSession.ToolCallError {
        dump(toolCallError)
    } catch {
        dump(error)
    }
    _ = session.transcript // read the full transcript of the LLM session so that you can see the history of which tools were used when.
}
```

Here we define a tool that the model can use to fetch the current time and date from the device.

## Why ISO 8601 is the Perfect Date Format for LLMs

One of the key challenges in this implementation is that we need a non-deterministic LLM to write unstructured data (a string) that can be deterministically converted into a structured type (a Swift `Date`). This is where [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format shines.

ISO 8601 is an excellent choice for LLM output because:

- **Highly structured and predictable**: The format follows strict rules that leave no room for ambiguity
- **LLMs have extensive training data**: ISO 8601 appears frequently in datasets, so models understand it well
- **Machine-readable**: Swift's `Date` can parse ISO 8601 strings reliably
- **Unambiguous**: Unlike formats like "1/2/2025" (which could be January 2nd or February 1st), ISO 8601 is clear

### Converting from String to Date with `@Guide`

The key to making this work is explicitly telling the LLM to use ISO 8601 format through the `@Guide` macro. Here's how we can enhance our tool to be more explicit about date formatting:

```swift
@Generable
struct DateRequest {
    @Guide(description: "The current date and time in ISO 8601 format (e.g., 2025-07-03T12:30:00Z)")
    let currentDateTime: String
    
    @Guide(description: "A human-readable version of the date for display purposes")
    let displayDate: String
}
```

By being explicit in our `@Guide` descriptions, we ensure the LLM outputs dates in a format that our Swift code can reliably parse into `Date` objects. 

## Unique Challenges When Teaching LLMs About Time

By default, the model doesn't know the current time. What I discovered during development is that Apple's models are strongly trained to tell users that they **cannot** tell the time. This creates a unique challenge: even when you provide the tools to fetch time, the model may refuse to use those tools.

The solution is to explicitly tell the model multiple times that it can use your tool to get the current time. Notice in the playground example how I include specific instructions:

```swift
instructions: "You can use tools to answer questions about the current date and time. e.g. 'What time is it?' or 'What day is it?'"
```

This explicit instruction overrides the model's default behavior and encourages it to use the tool when time-related questions are asked.

## Important Caveats and Limitations

Before you start building with Apple's FoundationModels framework, there are some important limitations to be aware of:

### Overly Aggressive Guardrails

Apple's models come with very conservative safety measures. As [officially documented](https://developer.apple.com/documentation/foundationmodels/improving-safety-from-generative-model-output), the framework is designed to be "overly aggressive" with guardrails. This means:

- The model may refuse to generate content that seems perfectly reasonable
- You might encounter unexpected restrictions on seemingly innocent requests
- Creative or open-ended tasks may be limited more than expected

Huge thanks to NatashaTheRobot for [pointing this out](https://www.natashatherobot.com/p/apple-foundation-models). 

### Test on Device, Not Simulator

This is crucial: **Do not rely on or trust the simulator to run FoundationModels code.** You need a device that can run Apple Intelligence (iPhone 15 Pro or later, or Mac with Apple Silicon).

The simulator may:
- Fail silently
- Provide misleading error messages
- Not accurately represent the model's behavior
- Miss device-specific optimizations

Always test your FoundationModels integration on actual hardware to ensure it works as expected in production.

## Key Takeaways

Teaching LLMs to tell time is just one example of the broader challenge of integrating real-time data with language models. Apple's FoundationModels framework provides powerful tools to solve this problem:

1. **Use the `Tool` protocol** to create functions that fetch real-time data
2. **Leverage `@Generable`** to deterministically constrain model outputs to structured formats
3. **Use `@Guide`** to provide clear instructions on what you'd like the model to output
4. **Choose ISO 8601** for String generations of dates to ensure reliable parsing
5. **Be explicit in your instructions** to override default model behaviors
6. **Test on actual devices** to ensure your implementation works correctly

The key insight is that we can bridge the gap between deterministic systems (APIs, databases) and non-deterministic AI by using structured interfaces and clear guidance. This pattern applies to many other real-time data integration challenges beyond just telling time.

What other real-time data challenges are you facing with LLMs? The same principles can be applied to weather data, stock prices, or any other dynamic information your applications need to access. 