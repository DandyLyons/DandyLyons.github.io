---
title: Hello Hugo
slug: hello-hugo
date: 2024-07-23
images: ["image.png"]
topics: ["Hugo"]
description: I've rewritten and released my personal site using Hugo!
---
Hello! 

Welcome to my personal site! Here I will be posting my projects and things I'm learning. 

I've recently rewritten this site in [hugo](https://gohugo.io/)! I appreciate how blazingly fast and customizable it is. The code for this site can be found [here](https://github.com/DandyLyons/DandyLyons.github.io). 

## Dev Diary
Now I'd like to share some of my journey of creating this site. 

When creating this site, I had a few priorities: 
1. It should be statically generated. 
2. It should be easy to write on using Markdown. 
3. It should be customizable.
4. It should support modern "tablestakes" website features. (dark mode, social previews, favicons etc.)
5. It should be developed in Swift. 

### Initial Priorities
#### It should be statically generated
One of my first encounters with the concept of statically generated sites was [Swift by Sundell](https://www.swiftbysundell.com). This has been one of my favorite blogs for years, and so eventually I learned that John Sundell created his site using something called Static Site Generation, which is when the entire site generated ahead of time statically. 

#### It should be easy to write on using Markdown
What attracted me to SSG was that I can write articles in simple Markdown. This is a lightweight simple syntax that allows me to just focus on the content. Furthermore, I can develop my site locally, and see my changes update in real time (much like a SwiftUI Preview), and then deploy my changes when I'm ready. 

I've also been an avid Obsidian user over the past few years. Markdown has become deeply ingrained into the way that I think and write. 

#### It should be customizable
In years past, on other sites, I've used Wordpress. It was liberating to see how powerful I could make my sites using themes and plugins. But inevitably, I would find a small little change that I wanted to make and it would be unsupported by the plugin. Or, I would have absolutely bizarre buggy behavior, only to evenutally discover that it was because the plugin was outdated, or conflicted with another plugin. This whack-a-mole was debilitating. 

This time around I knew that I needed a solution that was customizable. I'm too opinionated to be beholden to someone else's theme. But I also knew that, in my current situation, it was not tenable for me to create the entire site on my own. 

I knew HTML, CSS, and JavaScript. At least the core concepts. But I wasn't using it at a deep level. Certainly not on a regular basis. So I wanted a solution where the majority of best practices were just already included "for free" and instead I could just focus on the "small tweaks" that I wanted. 

#### It should support modern "tablestakes" website features
Today's readers just expect websites to be responsive. It should smoothly transition from Desktop, to tablet, to mobile. It should switch automatically between light and dark mode. It should display correctly when I share a link on social media. If any of these features are missing or buggy, then the site feels "janky" or "broken". 

#### It should be developed in Swift
Swift by Sundell is published using a Static Site Generator which he created called [Publish](https://github.com/johnsundell/publish). In fact, it really is quite a full featured suite, including a Markdown parser (Ink) and a HTML-like Swift DSL (Plot). This seemed to be my holy grail. I could develop for the web using the same tools that I use to develop for mobile. But I soon found a few issues. 

There were a few features that were missing. Thankfully, Publish has a great plugin system where you can add new features, but that leads to the second problem: there's not a huge community of Publish users. It was difficult to find example repos, or plugins that met my needs. 

It was certainly possible to create my own plugins, but that had two problems. First, creating those plugins would require deeper learning about both Plot (the HTML interpreter) and HTML itself. If I need to learn HTML anyways, I might as well just learn and write it in actual HTML. So this was my second problem: the promise of a primarily Swift workflow, seemed to not actually deliver. 

### The Trouble with DSL's
One of my takeaways from this experience is I started to learn some of the pros and cons of a DSL, or Domain Specific Language. For example with Plot we can write code like this: 

```swift
var body: Component {
  Article {
      Image(url: imagePath, description: "Header image")
      H1(title)
      Span(description).class("description")
  }
  .class("news")
}
```

This code is so cool and so powerful! As you can see, it is using the same names and concepts as HTML such as `<article>` and `<h1>` but it's written in native Swift code that is just like SwiftUI. It also comes with all the benefits of Swift such as static type checking. 

But what happens when you want to take a slight detour off the happy path? What happens when you need a feature that isn't natively supported? To be clear, I'm not trying to criticize John Sundell or his fantastic libraries. I'm just trying to point out that DSLs have a basically impossible task. It's not fair to expect a library owner to keep up with a mature, full-featured, decades old technology, with one of the largest dev communities in the world. 

Also, how transferrable are these skills? If I get really used to reading "html" code in a Swifty way, what am I going to do if I'm expected to work on a project that uses actual HTML code. The syntax is similar, but not the same. Will I ever be hired to a team that's working on a Plot stack. Probably not. 

On the other hand, what happens if I just grok and use actual HTML? Well that knowledge is transferrable to tons of domains. React uses `jsx` which looks and behaves much more like HTML. There are also templating languages like Django and Stencil which can use real HTML. By learning and using HTML, I am using a technology that is in demand, is mature, has a huge community, and is transferrable to many domains. 

But more importantly, now I have simplified the stack. I have one less system of complexity to consider. I no longer have to wonder if my DSL has generated the HTML code that I think it has. I can just write HTML code. 

### Revised Priorities
So it was with a heavy heart that I looked for a new solution. I was no longer prioritizing a Swift-first solution. I experimented with a few others along the way. 
- **Quartz**: Quartz turns an Obsidian vault into a publishable site. (It's a replacement for Obsidian Publish). 
  - For a while, I wondered if I could just host my blog inside of my Obsidian vault. 
  - Eventually I realized that it's just a different problem space with different needs. I still love Quartz and plan to use it in the future, but just for a *notes* section of the site, and not for the whole site. 
- **Jekyll**: I also tried Jekyll. 
  - In my limited time with it I discovered, I like Jekyll, but I'm not a fan of Ruby's developer experience. It took a very long time to install jekyll, mostly because it took a long time to install Ruby. 
  - But really, the thing that was the dealbreaker was that Jekyll takes too long to build and iterate. Especially, when I am first learning, it is vital that I get quick feedback so that I can verify that the changes that I'm making do what I think they are doing. 
  - In Jekyll, my build times were averaging between 1 and 1.25 seconds. That may not seem like much but that happens every single time my site hot reloads. It breaks your flow of though when you are constantly waiting for a tool to catch up. 
  - Even if Jekyll is usable now, I only have a few pages on my site. How much more will it slow down as my site grows over time? 
- **Hugo**: Finally, I tried Hugo, and the faster build times won me over: 
  - Currently my Hugo build times average to about 50ms. That's about a 20x increase in speed. That means faster build times, deploy times, and faster iterative renders. 

## Stop Looking for a Perfect Solution
But hugo is not without it's drawbacks. A small part of me misses jekyll's liquid templating language which is very similar to Swift's Stencil language. Both of those templating languages felt easier to read and understand. 

Hugo on the other hand uses Go's html/template library. Currently it feels less intuitive to me. But this is partly just because I've never learned Go before. But as I've seen with each solution that I've tried, there simply is no perfect solution. Everything has it's own set of tradeoffs. Know yourself, know your wants and needs, find something that works "well enough" and then just stick with it. Stop trying to look for the "optimal" solution. If the "optimal" solution takes you 5 times as long to find as something that is almost as good, then that makes it not very optimal. 

## Don't Be Afraid of Learning
Which brings me to my next takeaway: don't be afraid of learning. In SWE, we feel an immense pressure to "learn the right things". _Don't learn that language, no one is hiring for it anymore. You should learn this language instead._ It takes a very long time to learn a new language, framework, tool, or skill, and it can be incredibly demotivating to invest all that time and effort to learn it only to discover that it's not _in demand_, or _that's not the modern way to do it_. 

I was "afraid" to use native HTML and web technologies, because I was focused on mobile and Swift. Adding something else to my pile felt daunting. But when I finally gave in and tried it, I realized it wasn't so scary. Now, I have another tool in my toolbox and that's fantastic. 

There is a balance that is, perhaps, difficult to find. On the one hand, I've learned that it's simply impossible to "learn everything". You will become a jack of all trades and a master of none. And the world is simply too big. It simply isn't possible to keep up with everything. I think it's important to specialize and focus your learning. 

But now I can see that I focused so much that I missing out on valuable solutions right next to me. Even a surface-level knowledge of a wide variety of topics is valuable. While it may not be enough to tell you the solution to that problem, it could certainly point you in the right direction. 

## Looking to the Future
There's a part of me that feels like I've spent too much time writing and rewriting this personal site. Perhaps. But dwelling on that isn't going to help me going forward. Not only that, but these experiences are still valuable. They will shape and guide my direction going forward. Do you feel like your path has been a meandering waste? Maybe it's not such a waste. Personally, I like that Hugo uses Go's templating language. Hopefully it will provide me an opportunity to learn some Go basics. 

And with that, I'm reminded of this verse: 

>Not that I have already obtained all this, or have already been made perfect, but I press on to take hold of that for which Christ Jesus took hold of me. Brothers, I do not consider myself yet to have taken hold of it. But one thing I do: **Forgetting what is behind and straining toward what is ahead, I press on toward the goal** to win the prize of God’s heavenly calling in Christ Jesus.…
>- Philippians 3:12-14