---
date: 2024-10-01
title: "The Illusion of Simplicity: Understanding Complexity and Abstractions"
slug: the-illusion-of-simplicity
images: [""]
description: 
topics: ["Software Development", "Abstractions"]
---
# "The Illusion of Simplicity: Understanding Complexity and Abstractions"
I'm starting to see a pattern that seems to replay again and again. A shiny new technology comes out that solves a problem. A bunch of developers flock to it, evangelizing it to everyone else. Eventually the tech disappoints. The developers complain that the new solution is so complicated, and they long for the next shiny new thing. 

Surely this pattern has existed for a long time, and will continue to repeat. But why does it happen? I think it's because we have fallen for a fallacy. The fallacy is this: 

> X technology will make things simpler. 

It won't. It doesn't. That complexity still exists. The only difference is you are not handling it anymore. Now that technology is handling it. **The complexity is not eliminated. The complexity is delegated.**

The word for this is *abstraction*. 

## What Are Abstractions? 
How do you store a list of values? You use an array. That's an abstraction.<br>
How do you implement an array? You could use a linked list. That's another abstraction. That's an abstraction.<br>
How do you implement a linked list? Well you're going to need pointers.<br>
How do you implement pointers? Well a pointer is just a number pointing to a position in memory? 

As we can see above, abstractions do not eliminate complexity. They don't even reduce complexity. In fact, **abstractions actually always increase complexity**. 

## Why Do We Use Abstractions? 
So why do we use abstractions then? Because abstractions **delegate** complexity. This is what makes abstractions so powerful. 

If you want to store a list of values, you just use an array. You don't need to think about linked lists. You can just use the array type provided to you by a library. You have delegated away that complexity to something else. This now frees you to tackle larger, more complex problems. 

## The Problem With Abstractions
But what happens if the problem isn't really solved? Now you have to solve the problem. Except now the problem is bigger and more complex than it was before. 

Now you have to handle the complexity of the original problem **plus** the extra complexity of the abstraction! 

Each abstraction can fail in at least two ways: 
1. The abstraction can be broken, not fulfilling what it promised to do. 
2. The abstraction can "leak", meaning it doesn't actually hide the complexity. 

Even worse, the [Law of Leaky Abstractions](https://www.laws-of-software.com//laws/leaky-astractions/) essentially says that every abstraction will leak. 

>All non-trivial abstractions, to some degree, are leaky.
>
>-- Joel Spolsky, 2002

## Abstractions: Can't Live With 'em, Can't Live Without 'em
Well that settles it. Let's get rid of all abstractions. Keep things simple. 

If that's your attitude, then good luck. 

No one truly gets rid of all abstractions. Even by using a programming language you are already using an abstraction. You're not writing assembly. You're certainly not writing machine code. 

If you want to solve big problems, then that requires big complexity. And if you want to handle that complexity, you're going to need to delegate some of it with abstractions. 

## The Path Forward

Understanding these principles doesn't mean we should avoid abstractions or new technologies. Instead, it calls for a more nuanced approach:

1. **Thoughtful Adoption**: Carefully evaluate new tools and abstractions. Consider their long-term implications, not just short-term gains. Be aware that adding layers of abstraction may make individual components simpler, but always increase overall system complexity.
2. **Deep Understanding**: Strive to understand the layers beneath your abstractions. This knowledge is invaluable when abstractions leak. When[^1] issues arise, be prepared to dive into the layers of abstraction to identify root causes.
3. **Balanced Approach**: Use abstractions to manage complexity, but be prepared to handle the complexity they can't fully hide.
4. **Continuous Learning**: Stay curious about both high-level abstractions and low-level details in your field. Recognize that mastering a new abstraction is an investment. It may slow you down initially before it speeds you up.

[^1]: not if

## Escaping Abstraction Hell
So has your heart been broken by yet another framework with broken promises? Fret not. It's all a part of the process. Find another way to manage that complexity. Consider these options: 
1. **Eliminate**: Perhaps you don't need this abstraction. Consider removing it. 
2. **Delegate**: Perhaps you should replace your abstraction with a better fit. 
3. **Incorporate**: Perhaps your should add a new abstraction alongside your current abstractions.   

## Conclusion
Don't be afraid of complexity. Embrace it. Find the right abstractions that you are comfortable using. You can handle it. 

