---
title: "AI Is a Moving Goalpost" 
date: 2025-05-06T10:02:25-06:00
tags: 
    - "thoughts" 
slug: "ai-is-a-moving-goalpost" 

aliases:
    - "/thoughts/5/" 
description: 
---


The term "Artificial Intelligence," or AI, is a perpetually moving goalpost. What we consider "AI" today is vastly different from what we called "AI" in the past, and it's more than likely that this pattern will continue into the future.

## Early Examples of "AI"

When I was a kid, I spent countless hours playing games on the original PlayStation. One of my favorites was Twisted Metal, a chaotic car combat game. You could play with a friend using split-screen, or you could also play alone against computer-controlled opponents. Back then, we referred to these computer players as "AI."

Looking back from today's perspective, calling that AI seems almost silly. The "intelligence" exhibited by those car opponents was extremely limited. They had only one skill – playing that specific game. I'm certain that if I started watching Twisted Metal speedruns, I would see how players have utterly broken the AI, by discovering and exploiting its predictable behavior. At their core, these so-called **AI** were simple algorithms following a predefined set of instructions. While some were more cleverly coded than others, they were fundamentally deterministic and narrow in scope.

Contrast that with the AI we interact with today, especially large language models (LLMs).

## Modern AI: A Paradigm Shift?

Today's AI (e.g., LLMs and diffusion models) is a completely different beast and vastly superior. If you ask an LLM the same question multiple times, you'll often get slightly different answers. This non-deterministic behavior feels more sophisticated, less like a simple script. However, if you look under the hood, this non-determinism largely stems from the probabilistic nature of these models. They work by predicting the next likely token[^1], and developers intentionally introduce a degree of randomness, sometimes choosing the second, third, or even fourth most likely option rather than always the top one. Parameters like "temperature" and the use of different random seeds allow us to influence this variability.

[^1]: A token is a unit of text, which can be as short as one character or as long as one word (or even a few words). For example, "ChatGPT" is one token, while "Chat GPT" would be two tokens.

Regardless of the technical specifics, it's undeniable that today's AI represents a massive leap, a true paradigm shift compared to the "AI" of even three or four years ago.

## The Question: Have We "Cracked" It?

Given this rapid evolution, what makes us so confident that we've finally "cracked it" now? What makes us think that there won't be future paradigm shifts just as significant, if not more so?

It seems very likely that a future generation will look back at the AI we have today and think, "Oh, that's quaint. They called *that* AI back then, but *this* new thing – *this* is the real AI."

## AI as an Alias for the Cutting Edge

The term "AI" has historically served as an alias for whatever is currently at the absolute cutting edge of software capabilities. When a new technological advancement pushes the boundaries of what software can do, we label it "AI." But as that technology matures and becomes commonplace, it no longer feels like the "cutting edge," and the term "AI" is then applied to the *next* breakthrough.

We can see a bit of this tension in AI definitions on the Wikiepedia page for [Artificial intelligence in video games](https://en.wikipedia.org/wiki/Artificial_intelligence_in_video_games). Parts of this page feel like an argument saying _"Well, that's not **real AI**. Look at **this**. This is **real AI**."_

>The term game AI is used to refer to a broad set of algorithms that also include techniques from control theory, robotics, computer graphics and computer science in general, and so video game AI may often not constitute "true AI" in that such techniques do not necessarily facilitate computer learning or other standard criteria, only constituting "automated computation" or a predetermined and limited set of responses to a predetermined and limited set of inputs.
>- [Artificial intelligence in video games](https://en.wikipedia.org/wiki/Artificial_intelligence_in_video_games)

Terms are important and I don't blame the authors of this page for trying to draw a line between what they consider "true AI" and what they consider "automated computation." But I think this is a bit of a red herring. When these technologies were first developed, they were still cutting edge. We didn't realize how limited they were. 

## The 1952 UNIVAC I Election Prediction

Consider a historical example: the 1952 US presidential election. CBS News used the **UNIVAC I** computer to predict the outcome – the first time a computer was ever used for this purpose on a major broadcast. Initially, the UNIVAC predicted a landslide victory for Dwight D. Eisenhower, a result that seemed improbable based on early returns. The CBS statisticians were so skeptical they actually delayed reporting the computer's prediction. Yet, as more votes were counted, the UNIVAC's forecast proved to be remarkably accurate. While it was a marvel for its time, using statistical data to aid predictions, by today's standards, we recognize it was essentially a sophisticated statistical model – a program, certainly not conscious or thinking in the way we understand it.

Now, such a statistical model is so commonplace that, for decades, the media has confidently declared the winning presidential candidate, less than 24 hours after polls close, and long **before** the final votes are counted. We look back and might find it amusing that people ever thought that UNIVAC was superintelligent, but people in the 50s should be forgiven for this. It is all too easy for us to see the error in their thinking, but we have the benefit of hindsight.

>**Side note:**
>At the time, this machine was portrayed as a super-intelligent entity, with the broadcast even simulating a natural language conversation between a human and the "AI." Look at [this excerpt from the CBS broadcast](https://youtu.be/nHov1Atrjzk) at 1:05. The reporter speaks to the UNIVAC I, machine in natural language, plain English, on camera, as if the machine has any way of understanding what he is saying. But this is just a silly farce. The UNIVAC I had no large language model, and certainly no understanding of natural language. It **did** have a sophisticated statistical model, but the whole "talking to the machine" schtick was just silly media nonsense theatrics. 

## Conclusion

If we feel so much smarter looking back at their definition of AI, perhaps we should pause and ask ourselves: What will the next generation think of *our* AI? The moving goalpost suggests they'll likely see it as just another step on a much longer journey.
