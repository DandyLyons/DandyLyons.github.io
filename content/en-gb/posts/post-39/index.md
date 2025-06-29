---
title: "How to Teach LLMs to Tell Time: Tool Calling with Apple Foundation Models"
slug: teach-llms-to-tell-time
date: 2025-06-23T12:39:00.000Z
author: Daniel Lyons
tags:
  - programming
topics: ["AI", "LLMs", "Large Language Models", "Programming", "Apple Foundation Models"]
---

In July 2024, Anthropic [revealed their system prompts to the public](https://docs.anthropic.com/en/release-notes/system-prompts). This taught the community [a ton of valuable insights about how to properly prompt engineer](https://simonwillison.net/2025/May/25/claude-4-system-prompt/). One interesting insight that we learned is that the prompt immediately tells the model what the current date is. This teaches us about a limitation of virtually all LLMs: they don't know how to tell time. It also shows us how to solve this problem: let's just tell them what the time is. 

## LLMs Can't Tell Time. Why is that such a big deal? 
LLMs rely on whatever is in their training data. Inevitably this will be out of date, especially with real-time knowledge like knowing the current date or time. 

Some tasks **require** users the model to know the current time. For example if the user asks *what's the weather like tomorrow?*. 

## Why Is This Problem Hard? 
LLMs are inherently ill suited to solve this problem. They can only output something that is in their training data and it takes way too long to add info to training. We can't get real-time data. 

Thankfully, getting real time data is really easy. We have tons of APIs. 

The problem is that these real-time data systems require predictable inputs or they will simply fail. **The real problem is that we want predictable systems (APIs and other traditional software) to interact with non-predictable systems (Large Language Models).** 

| **Traditional Software** (Deterministic)                                          | **Modern AI** (LLMs, Diffusion etc.) (Non-Deterministic) |
| --------------------------------------------------------------------------------- | -------------------------------------------------------- |
| Requires **predictable inputs in a specific structure** or it will fail or error. | Can handle unpredictable unstructured inputs.            |
| Creates predictable, structured outputs.                                          | Creates unpredictable, unstructured outputs.             |

## How the Problem Got Solved
The FoundationModels framework comes with various tools to help solve this problem. 

### The `@Generable` Macro
This macro programmatically constrains the model to output data that matches your type. 
It also prompts the model and tells the model what kind of data you are looking for. 
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

#### The `Guide` Macro
Provides extra guidance on what type of data should be in a property. 
You can provide extra prompting to tell the model info about the property. 
**You can programmatically constrain the results.**

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
This makes it really easy to try code directly in Xcode and see results in place. 
This is especially important when interacting with LLMs where the tiniest difference in text can result in very different behavior. 

## Building a Time Fetching Tool
Here is my gist that I built: 

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

### Unique Challenges
By default the model doesn't know the current time. 
So I noticed that any time I ask to do something 
So I need to explicitly tell the model multiple times that it can use my tool to get the current time. 