---
title: "Actually Useful AI: Modern Search"
date: 2025-05-30T13:14:22-05:00
draft: false
slug: actually-useful-ai-modern-search
description: Go beyond keywords with LLM-powered search. Learn how AI is
  revolutionizing information retrieval, its unique use cases, critical
  weaknesses, and tips for effective searching.
tags:
  - thoughts
aliases:
  - /thoughts/9/
---
## Introduction: New Dog, Old Tricks

It's funny how history repeats itself. Every time we get a groundbreaking new technology, our first instinct is often to just use it for the old things we were already doing, just maybe a little bit better. Think about movies back in the day. When they first came out, filmmakers basically just pointed the camera at a stage play. All the techniques, the blocking, the acting – it was all just lifted from the theater. It took time for them to figure out what _only_ a movie could do, things like close-ups, dynamic editing, and special effects that are impossible on stage.

Likewise, when the current wave of powerful Large Language Models (LLMs) like ChatGPT first burst onto the scene, what did most of us do? We couldn't help but use it for the thing we do literally all the time: a simple Google search. We'd type in a question, hoping the LLM would just spit out the answer it found somewhere.

But that's changing. Today, we're going to dive into using LLMs for search in ways that were genuinely never possible before these modern models came around. It’s time to stop just pointing the camera at the stage play and start making movies.

## The Tools of the New Paradigm

So, what are the tools enabling this shift? A few major players have emerged, essentially wrapping powerful LLMs in interfaces designed to tackle search-like tasks. We're talking about products like:

• **Perplexity.ai:** A dedicated interface built around using LLMs to find and synthesize information from the web.
• **ChatGPT's search mode:** This allows the LLM to actually go out and perform web searches.
• **Google's new AI Mode:** Google's own foray into integrating LLM capabilities directly into search results.

All three of these are, at their core, an LLM chatbot enhanced and designed to meet the demands we traditionally threw at search engines, but with a new approach.

## Understanding The Tools Within LLM Powered Search

It’s important to understand what’s actually going on under the hood with these tools, because not all LLM capabilities are created equal.

### The Chatbot

At its most basic, you just have the core LLM. This is essentially a highly sophisticated text generator. It’s been trained on massive amounts of data and is excellent at predicting the next word in a sequence, allowing it to "write" coherent and often very helpful text. But what are the weaknesses of a plain LLM? No built-in memory of past messages, and absolutely no access to the internet or any external files. It just writes text based on its training data and the current prompt. (In fact, the LLM doesn't even remember past messages. Under the hood, ChatGPT is sending in the entire chat history of the thread to the LLM every single time you send a new message!)

### Multimodal LLMs

Then came the evolution where model makers like OpenAI and Google started teaching these models to "read" and generate more than just text. What if you treated images, PDFs, audio, or even code as another form of "language"? Now you have multimodal LLMs that can analyze an image and describe it, or read a PDF document and answer questions about its content. These capabilities are increasingly being built directly into the model itself – it's part of its fundamental architecture.

### The Chatbot with Tools

This is where many of the products you interact with daily come in. They combine a core LLM with _external tools_. This is key: the LLM itself doesn't have web access or the ability to create documents natively. Instead, the LLM acts like a conductor. It reads your request and generates text that serves as a command or instruction for a separate tool to execute. Once the tool finishes its job, it sends the result back to the LLM, which then "reads" that output and uses it to formulate its response to you. Let's look at some common examples of these tools:

#### Web Search
This is probably the most common tool. The LLM takes your prompt, figures out what search queries to run, sends them to a search engine (often Google or Bing behind the scenes), gets the results, and then reads those web pages to synthesize an answer.

#### "Canvas"
Some interfaces allow the LLM to interact with a document or a structured workspace, letting it draft text, add elements, or iterate on content. The LLM is commanding the canvas tool to perform these actions.

#### "Research" / Enhanced Search Modes
Products like Perplexity have a "Research" mode, and others have similar features often branded differently. What these typically do is automate a multi-step process. The LLM might decide it needs to do several rounds of web searching, maybe outline a plan, execute searches based on that plan, read results, synthesize, and refine. This allows them to tackle more complex queries than a single search might handle, but remember, they are still fundamentally performing and processing multiple old-school searches. They still suffer from the core weaknesses of the LLM interpreting the results.

#### "Deep Thinking" / Problem Solving Modes
Most major model providers have modes with names like "deeper thinking" or "advanced reasoning." My intuition is that these are often variations on the "Research" pattern – perhaps more focused on applying logic or structured problem-solving patterns to the information gathered. While "Research" feels geared towards writing reports or summarizing complex subjects, "Deep Thinking" seems aimed at applying existing solutions or frameworks to new problems, even if they aren't capable of truly _inventing_ novel solutions from scratch. The mechanism likely still involves planning and iterative processing via external tools.

## The New Paradigm (LLM-powered search) Is Built on the Old Paradigm (Keyword-based search)

This is a crucial point to internalize: the shiny new LLM-powered search tools aren't magic boxes that bypass the internet. They are, for the most part, performing the same fundamental keyword-based searches we were already doing. They’re just automating a bunch of the steps for us.

Think about it: the LLM reads your nuanced, natural language prompt. It then _translates_ that prompt into the kind of specific keyword queries that traditional search engines understand. It sends those queries out, gets the list of search results (often still relying on the search index of giants like Google, as virtually every alternative search engine does), and then the LLM _reads_ the content of those pages to generate its answer. It's a powerful new layer on top of the existing search infrastructure.

## Understanding the Limitations of the Old Search Paradigm

To really appreciate what LLMs can do, let's quickly remind ourselves of the headaches of the old keyword-based search paradigm:

• It fundamentally relied on matching keywords. You had to guess what words the page you wanted might contain.
• While Google got better over time, it struggled to truly understand the _meaning_ of a full sentence or the _intent_ behind a query. It was mostly sophisticated pattern matching and ranking.
• It was terrible at questions where there was no single obvious keyword.
• Asking "how do I" questions often resulted in a list of pages that _might_ contain the instructions, forcing you to click through and piece together the answer yourself.

## Use Cases Uniquely Suited for LLM-Powered Search

This is where the new paradigm shines. Because LLMs understand context, relationships between ideas, and can synthesize information, they unlock search possibilities that were clunky or impossible before.

### Why LLMs Excel
Instead of just keyword matching, LLMs grasp the semantic meaning of your query. They understand the relationships between different pieces of information found across multiple sources and can synthesize them into a coherent answer. They don't just give you links; they give you a summary, a comparison, or a direct answer extracted from the web. This ability is what makes them uniquely capable of handling complex, vague, or comparative queries that would stump traditional search.

### Examples of these new possibilities

#### Retrieving Information from Vague Descriptions
Remember trying to find something you vaguely recall? Now you can ask:

◦ "I remember an episode of Spongebob where [describe a scene]. What was that episode?"
◦ "What's that one song that talks about [describe the theme or a lyric fragment]?"
◦ Finding information based on scenario: "I need a recipe for a quick dinner using chicken and whatever vegetables I might have on hand." (The LLM can interpret "whatever vegetables" and find recipes that fit the flexible criteria).

#### Complex Comparisons and Analysis
No more opening ten tabs to compare products or concepts manually. LLMs can do the heavy lifting:

◦ "Compare product A and B. I care about these features: [list features]. What other features should I be considering?"
◦ "Compare the features and pricing of three different project management software options, focusing on ease of use for small teams."
◦ "Analyze the pros and cons of using [technology A] vs. [technology B] for building a [type of application]."

#### Summarizing and Explaining
Get straight to the point or understand complex topics quickly:

◦ "Summarize the key findings of the recent report on [topic]."
◦ "Explain the concept of [technical term] in simple terms."

#### Converting From One Format To Another
- "Summarize this buying guide as a table."
- "Convert this JSON data into a CSV file."

#### Researching Relationships and Effects
Understand causality and connections between events or concepts:

◦ "What were the main causes and effects of [historical event]?"
◦ "How does [concept A] relate to [concept B] in the field of [subject]?"

#### Exploring Ideas and Recommendations
Get tailored suggestions based on your needs:

◦ "Recommend a good podcast about [topic] that is suitable for beginners."

## Weaknesses of LLM Powered Search

Now, before you ditch Google entirely and rely solely on chatbots for everything, let's talk about the not-so-shiny parts. LLM-powered search has significant weaknesses you _must_ be aware of.

### They Hallucinate
This is the most notorious weakness. LLMs can confidently state incorrect information or invent facts out of thin air. They don't know what they don't know, and they are compelled to generate a response even if they lack accurate information.

### Therefore, You Have to Verify Their Writing
Because of hallucinations and the lack of true reasoning, you absolutely _cannot_ blindly trust the output of an LLM-powered search. If the information is important, you _must_ verify it using other reliable sources.

### They are Not Actually Reasoning
This is perhaps the most crucial point. As research, like the recent paper from Apple titled [The Illusion of Thinking](https://ml-site.cdn-apple.com/papers/the-illusion-of-thinking.pdf) suggests, these models aren't actually "thinking" or reasoning in a human sense. They are incredibly complex pattern-matching and text-generation machines. They are brilliant at predicting the next token based on the vast data they trained on, which _looks_ like intelligence, but isn't.

### Even "Reasoning" Steps Can Be Unreliable
Techniques like "Chain-of-Thought" were introduced to make models explain their steps, making them seem more transparent and reliable. However, [research shows](https://www.anthropic.com/research/reasoning-models-dont-say-think) that the steps they output when asked "how did you get that answer?" might not actually reflect the internal process the model used to generate the initial response. They can essentially hallucinate their own explanation after the fact. So, you can't fully trust that the chain-of-thought accurately represents their actual "thought process."

### Yes, They Cite Their Sources, but Even Those Have Mistakes
A great feature is that these products often inline cite their sources, letting you click through to the original page. This _should_ help with verification, but I've found two major problems:

a. **Poor Source Trustworthiness Judgment:** LLMs don't seem to be very good at evaluating whether a source is trustworthy. They routinely fall for jokes or satire and often treat outdated sources with the same authority as brand new ones. They also don't seem to understand that for some subjects (like breaking news), you should actually place _less_ trust in brand new, unverified sources because the story is still developing.

b. **Phantom Citations:** Often, I click on a cited link, and the page straight up _never mentioned_ the fact the LLM attributed to it. It's like the model was programmed to cite _something_ and just picked a random link from the search results it processed. It's incredibly frustrating and undermines the verification feature.

### The Honeymoon Won't Last Forever
Right now, many of these products deliver answers incredibly fast, for little to no cost, with minimal or zero ads. This is fantastic! But running these powerful models and their associated search infrastructure is expensive. These companies have massive costs, and eventually, they _will_ pass that on to us, the users. [Enshittification](https://en.wikipedia.org/wiki/Enshittification) is likely inevitable. Enjoy the current state while it lasts, but be prepared for things to change.

## Tips for LLM Powered Search

Given the power and the pitfalls, here are some tips for getting the most out of LLM-powered search while navigating its weaknesses:

### Feel Free to Use Natural Language
This is the primary value proposition! Don't feel like you have to revert to chopped-up keyword phrases. Ask your question as you would to an expert sitting next to you. This allows the LLM to leverage its understanding of language.

### Don't Stop Using Keywords (Especially for Specifics)
While natural language is great, precision helps. If you're asking about a specific product, person, or concept, include the exact name or jargon within your natural language prompt. Instead of saying "the new iPhone," say "the iPhone 16 Pro." This gives the underlying keyword search mechanism the best chance of finding highly relevant source material for the LLM to process, increasing the likelihood of accurate results. Be careful about using relative terms like *the latest*, or *last year's*. While LLMs can handle these terms, it requires extra work and complexity for them. 

### Understand What Makes a "Weak" Question
Before you hit send, pause and ask yourself: "If I asked a human expert this question, would they understand exactly what I'm asking and how to find the answer?" Put yourself in the shoes of the answerer. LLMs are powerful, but they can't read your mind. If your question is so vague, ambiguous, or requires external context only you possess, a human expert couldn't answer it reliably, and neither can an LLM. Be as clear and specific as possible about what you need and the context surrounding it.

## Conclusion: The Future of Information Access - With Caveats

The advent of modern LLMs is undeniably ushering in a new era for how we access information. We're moving beyond the limitations of simple keyword matching to a world where search tools can understand the nuance of natural language, synthesize information from multiple sources, and directly answer complex questions that were previously hard to tackle. This unlocks exciting new use cases, allowing us to find information based on vague recollections, perform detailed comparisons effortlessly, and get quick summaries of complex topics.

However, it's critical to approach this new paradigm with open eyes. These tools are not infallible truth machines. They hallucinate, they don't truly reason, their explanations of _how_ they got an answer might be fabricated, and their source citation is often unreliable. We have to remain critical users, verifying important information and understanding that the smooth, confident answer we receive is a generated text output, not necessarily the result of genuine understanding or foolproof fact-finding.

LLM-powered search is a powerful layer built upon the existing foundation of web search. It automates and enhances our ability to find information, pushing the boundaries of what's possible. As the technology evolves, and potentially adapts to new business models, understanding how these tools work – their strengths, their weaknesses, and the best ways to interact with them – will be key to effectively navigating the future of information access. So, explore these new tools, ask those complex questions, but always remember to verify, verify, verify.
