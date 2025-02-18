---
title: "Actually Useful Obsidian: Links"
date: 2025-02-25
tags: ["Obsidian"]
series: ["Actually Useful Obsidian"]
image: 
description: 
slug: actually-useful-obsidian-links
draft: true
---
The following is my very rough draft outline of the blog that I am writing below. 
### The Power of Links

#### Graph View

#### Forward Links

#### Backlinks

### External Links
- External link: `[Google](https://www.google.com)` 
- precede any link with `!` 
- Link shortcut: 
	- 1. Highlight text
	- 2. Use Obsidian Command: *Insert Markdown link*
### Internal Links
Obsidian supports the following link formats:

- Markdown: `[Three laws of motion](Three%20laws%20of%20motion.md)`
	- Markdown (simpler formatting): `[Three laws of motion](<Three laws of motion.md>)` 
- Wikilink: `[[Three laws of motion]]`
	- Wikilink with alias: `[[Three laws of motion|3 laws of motion]]` 
- Heading Wikilink: 
	- **heading in another note**: `[[Three laws of motion#first law]]`
	- **heading in the same note**: `[[#first law]]` 
- Link to a block: 
	- `[[Three laws of motion#^37066d]]`
### Non-Graph Links: External Links to Internal Files
- External link to internal file:
	- **Copy Obsidian URL**: `[Three laws of motion](obsidian://open?vault=content&file=Three%20laws%20of%20motion)`  
	- **Advanced URI: Copy URI for Current File**: 
		- **With UUID**: `[Three laws of motion](obsidian://adv-uri?vault=content&uid=6e80cd59-8be7-4bce-a8ab-b1752d7a9ff1)`
		- **With Human Readable ID**: `[Three laws of motion](obsidian://adv-uri?vault=content&uid=beaver)` 

### Aliases
- Wikilink with alias: `[[Three laws of motion|3 laws of motion]]` 
- Markdown with alias: 
	- `[3 laws of motion](Three%20laws%20of%20motion.md)` 
### Embed Files
- precede any link with `!` 
- Another internal file
	- A Section of another file (picked by heading)
	- A "Block" of another file
- Fantastic for embedding: 
	- YouTube videos
	- Images
	- PDF Files
	- Webpages: 
		- [[Auto Link Title]] 
		- [[Link Embed]] plugin
		- [[Auto Embed]] plugin: Adds support for embeds of Notion, Reddit, Mastodon and other sites. 

---
# Actually Useful Obsidian: Links
Last week we started a new series entitled _Actually Useful Obsidian: Links_. In this series, we explore the most helpful and important features of Obsidian. But don't be fooled. **This series is not just for beginners.** Even if you have been using Obsidian for a while, you will most likely find some new tips and tricks that you didn't know about. Let's focus on one of Obsidian's most powerful features: Links.

Note: You can follow along in this guide, but you will get much more out of it if you have many notes in your vault already. If you only have a few notes in your vault, then I recommend opening the Sandbox vault that comes with Obsidian. To open it, click the ? icon in the lower left corner of the Obsidian window and select "Open Sandbox Vaul".

## The Power of Links
Links are one of the most powerful features of Obsidian but it may not be immediately obvious why. What is the big deal? Unfortunately, plain old links can be a bit underappreciated.

To demonstrate the power of links we'll need to look at another feature of Obsidian: the Graph View.

### Graph View
Unlike plain old links, the Graph View is perhaps a bit _overappreciated_. It is a visual representation of all the notes in your vault and how they are connected. It is a powerful tool for seeing the connections between your notes and for discovering new connections that you didn't know existed. At least, that is the theory. In practice, the Graph View can be a bit overwhelming. It can be hard to see the forest for the trees. There are many ways to open the Graph View. You could click on the Graph View icon in the left sidebar. Or you could use the keyboard shortcut[^1]. But I strongly recommend using the Obsidian Command Palette[^2]. Just press `⌘ P` and type "Graph View".

[^1]: The default keyboard shortcut on macOS is `⌘ ⇧ G`.
[^2]: Turn on the Core Plugin "Command Palette" to enable this feature if you haven't already.

As you can see, the Graph View is very pretty, and perhaps it makes for a very interesting post on social media, but it's not exactly the most helpful view. Many of the nodes are too small to read and the connections are too numerous to make sense of. But there is another view that tends to be more helpful: the Local Graph View. 

### Local Graph View
Use the Command _Graph view: Open local graph_. Now we see a graph of only the notes that are linked to the current note. This is much more manageable. We can see our current note in the middle and all the notes that are linked to it. You can also click on any of the linked notes to jump to that note and see their connections. This is a very powerful tool for seeing the connections between your notes. But how do we create these connections?

### Forward Links


### Backlinks

## External Links

## Internal link

## Non-Graph Links: External Links to Internal Files

## Aliases

## Embed Files
