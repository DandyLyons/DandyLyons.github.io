---
title: "Actually Useful Obsidian: Links"
date: 2025-02-25
tags: ["Obsidian"]
series: ["Actually Useful Obsidian"]
image: 
description: 
slug: actually-useful-obsidian-links
---
Last week we started a new series entitled _Actually Useful Obsidian: Links_. In this series, we explore the most helpful and important features of Obsidian. But don't be fooled. **This series is not just for beginners.** Even if you have been using Obsidian for a while, you will most likely find some new tips and tricks that you didn't know about. Let's focus on one of Obsidian's most powerful features: Links.

> 🆕 **New to Obsidian?**  
> You can follow along using Obsidian's built-in Sandbox vault. To access it, click the ? icon in the lower left corner and select "Open Sandbox Vault". This gives you a pre-populated vault to experiment with.

## The Power of Links
Imagine having your own miniature version of the internet, but filled entirely with your thoughts, ideas, and discoveries.[^asWeMayThink]  Today, Obsidian brings this vision to life through its powerful linking system.
Links are one of the most powerful features of Obsidian but it may not be immediately obvious why. What is the big deal? Unfortunately, plain old links can be a bit underappreciated.

To demonstrate the power of links we'll need to look at another feature of Obsidian: the **Graph View**.

[^asWeMayThink]: This isn't just a modern convenience - it's the realization of Vannevar Bush's 1945 vision of the Memex, a device he described in his influential essay [As We May Think](https://www.theatlantic.com/magazine/archive/1945/07/as-we-may-think/303881/).

### Graph View
Unlike plain old links, the Graph View is perhaps a bit _overappreciated_. It is a visual representation of all the notes in your vault and how they are connected. It is a powerful tool for seeing the connections between your notes and for discovering new connections that you didn't know existed. At least, that is the theory. In practice, the Graph View can be a bit overwhelming. It can be hard to see the forest for the trees. There are many ways to open the Graph View. You could click on the Graph View icon in the left sidebar. Or you could use the keyboard shortcut[^1]. But I strongly recommend using the Obsidian Command Palette[^2]. Just press `⌘ P` and type "Graph View".

[^1]: The default keyboard shortcut on macOS is `⌘ ⇧ G`.
[^2]: Turn on the Core Plugin "Command Palette" to enable this feature if you haven't already.

As you can see, the Graph View is very pretty, and perhaps it makes for a very interesting post on social media, but it's not exactly the most helpful view. Many of the nodes are too small to read and the connections are too numerous to make sense of. But there is another view that tends to be more helpful: the Local Graph View. 

### Local Graph View
Use the Command _Graph view: Open local graph_. Now we see a graph of only the notes that are linked to the current note. This is much more manageable. We can see our current note in the middle and all the notes that are linked to it. You can also click on any of the linked notes to jump to that note and see their connections. This is a very powerful tool for seeing the connections between your notes. But how do we create these connections?

### Forward Links
Making a link is very simple. Simply type `[[` and then start typing the name of the note you want to link to. Obsidian will suggest notes that match what you have typed. You can select one of the suggestions by pressing `Enter`. This will create a link to that note. You can also create a link by using the Obsidian command _Add internal link_. Now we have link that we can click on to jump to that note. This is called a _forward link_. If you still have the Local Graph View open, you will see the new link appear in the graph. We've just made a connection between two notes. But this alone isn't all that powerful. The real power of links comes from _backlinks_.

```markdown
# Note A
This is a note that links to [[Note B]].
```

### Backlinks
If you create a link from _Note A_ to _Note B_ then you now have _forward link_, but behind the scenes, Obsidian has also created a _backlink_ from _Note B_ to _Note A_. This means that every single note in Obsidian knows all the other notes that link to it. Let's see it in action. 

Open _Note B_ and run the action called _Backlinks: Open backlinks_[^core-plugin] from the Command Palette. You will see a list of all the notes that link to _Note B_. 

[^core-plugin]: This feature is part of the Core Plugin. If you don't see it, you may need to enable the "Backlinks" Core Plugin.

#### Linked and unlinked mentions
There are two sections in the backlinks pane: _Linked mentions_ and _Unlinked mentions_. _Linked mentions_ are notes that are explicitly linked to _Note B_. _Unlinked mentions_ are notes that mention _Note B_ but are not linked to it. This is a very powerful feature. It means that you can discover connections between notes and ideas that you didn't know existed. On top of that, if you hover your mouse over a backlink, you will see a "Link" button that you can click to automatically convert the unlinked mention into a link! 

## External Links
So far we have only talked about _internal links_. But Obsidian also supports external links. You can create an external link by using the Markdown syntax: `[Obsidian](https://obsidian.md)`. This will create a link to Obsidian's website. But we can link to far more than just websites. We can link to **any URL at all**. Including: 

- **Other notes in your vault**: `[Three laws of motion](Three%20laws%20of%20motion.md)`
- **Other files outside of your vault**: `[My Resume](file:///Users/username/Documents/Resume.pdf)`
- **Phone numbers**: `[Call me](tel:555-555-5555)`
- **Email addresses**: `[Email me](mailto:person@example.com)`
- **Calendar events**: `[Meeting](webcal://example.com/meeting.ics)`

**NOTE**: Remember that URLs must always be [percent-encoded](https://en.wikipedia.org/wiki/Percent-encoding). This is just like any other URL you would use on the web.

In addition, we can also link to "actions". We can call URI schemes that not only open up some piece of content, but also perform some action. Theres an inexhaustible list of URL schemes from all kinds of apps but here are some of my favorites. 

### Obsidian URI Schemes
Obsidian has a robust [URI scheme](https://help.obsidian.md/Advanced+topics/Using+obsidian+URI) that allows you to do all kinds of things. Here are some of the most useful ones:

- **Open a note**: `[Three laws of motion](obsidian://open?vault=content&file=Three%20laws%20of%20motion)`
  - Note: If your file name changes, or if it moves then this link will no longer work. No problem. There's a better solution below. 👇🏼
  - **Open a note at a specific heading**: `[First Law](obsidian://open?vault=content&file=Three%20laws%20of%20motion%23first%20law)`
- **Open another vault**: `[Sandbox](obsidian://open?vault=Sandbox)`
- **Edit an existing note**:
  - **Prepend text to a note**
  - **Append text to a note**
- **Open a daily note**: `[Today](obsidian://daily?vault=content)`

### Obsidian "Advanced URI" Plugin Schemes
But there is also a plugin called [Advanced URI](https://publish.obsidian.md/advanced-uri-doc/Home) that allows you to do even more. You can use this plugin to run any action that you can do in Obsidian. Here are some of the most useful ones:

- **Open a note by its UUID**: `[Three laws of motion](obsidian://adv-uri?vault=content&uid=6e80cd59-8be7-4bce-a8ab-b1752d7a9ff1)`
  - To use this, you first need to call the command "Copy URI for Current File" from the Command Palette. When you run this command, it will first add the UUID to the frontmatter of the note and then copy the URI to the clipboard. This is great because it means that even if you change the name of the file, or move it to a different folder, the link will still work.
- **Open a bookmark**: `[Three laws of motion](obsidian://adv-uri?vault=content&bookmark=three%20laws%20of%20motion&openmode=tab)`
- **Open a settings page for a specific plugin**: `[Settings](obsidian://adv-uri?vault=content&settingid=my-community-plugin-id)`

### Apple Shortcuts URI Schemes
If you are on an Apple device, you can also use the [Shortcuts app](https://support.apple.com/en-us/HT208309) to create custom URI schemes. This means that you can create your own Shortcuts in the Shortcuts app and then create a convenient link to run that Shortcut from Obsidian! Here are some examples:

1. **Run a specific shortcut**:  `[Run MyShortcut](shortcuts://run-shortcut?name=MyShortcut)`
2. **Create a new shortcut**: `[Create New Shortcut](shortcuts://create-shortcut)`
3. **Open a specific shortcut for editing**: `[Edit MyShortcut](shortcuts://edit-shortcut?name=MyShortcut)`
4. **Run a shortcut with text input**: `[Run MyShortcut](shortcuts://run-shortcut?name=MyShortcut&input=Hello%20World)`
5. **Run a shortcut with clipboard input**: `[Run MyShortcut](shortcuts://run-shortcut?name=MyShortcut&input=clipboard)`
6. **Open the Shortcuts Gallery**: `[Open Gallery](shortcuts://gallery)`
7. **Search the Shortcuts Gallery**: `[Search Gallery](shortcuts://gallery/search?query=photos)`


## Non-Graph Links: External Links to Internal Files
> NOTE: 
> Honestly, this section is something that not everyone should care about. **If you are just getting started then don't worry about non-graph links.** It's nice to be aware of them, but it's really not a big deal. But if you have been using Obsidian for a while and you have a lot of notes in your vault, then you may find this section helpful.

Now it should be noted that **external links can only be forward links**. Obsidian will not create a backlink for external links, which of course makes sense, since there would be no way to create a backlink from an external source. But we can actually use this to our advantage because it helps us to mitigate a common problem in Obsidian. 

Many people start using Obsidian because they love the Graph View. They love the idea of seeing all their notes and how they are connected. But then they realize that the Graph View is not as helpful as they thought it would be. It is too overwhelming. There are too many connections. It is hard to see the forest for the trees. The problem is that we have too many connections and many of them are not relevant. 

So now we are in a bit of an awkward position. It is nice to have links between notes, because it helps us to navigate between notes but it can also clutter up the Graph View with irrelevant connections. So what do we do? If only there was a way to link without creating a connection.

Well there is. We can use external links to link to internal files. This creates a convenient link, but it does **not** clutter the Graph View. And it's not difficult to do: 

1. **Copy a URL to the note**: You can use either the built-in command "Copy Obsidian URL" or the Advanced URI plugin to copy a URL to the note.
2. **Write the text for the visible part of the link**: `Three laws of motion`
3. **Highlight the text that you want to link**
4. **Use the Obsidian Command**: *Insert Markdown link*. (By default, the keyboard shortcut is `⌘ K`)
5. **Paste the URL**: `[Three laws of motion](obsidian://open?vault=content&file=Three%20laws%20of%20motion)`
6. **Done!**



## Embed Things
So far we have only talked about clickable links. But Obsidian also supports embedded links. You can add `!` in front of any link to embed that content directly into your note. You can embed all kinds of content including:

- **YouTube videos**: `![[https://www.youtube.com/watch?v=dQw4w9WgXcQ]]`
  - This will embed a fully functional YouTube video directly into your note. You can play the video directly inside Obsidian!
- **Images**: [How to embed an image in Obsidian](https://help.obsidian.md/Linking+notes+and+files/Embed+files#Embed+an+image+in+a+note)
- **PDF Files**: [How to embed a PDF in Obsidian](https://help.obsidian.md/Linking+notes+and+files/Embed+files#Embed+a+PDF+in+a+note)
- **Audio Files**: [How to embed an audio file in Obsidian](https://help.obsidian.md/Linking+notes+and+files/Embed+files#Embed+an+audio+file+in+a+note)
- **Saved Searches in Obsidian**: [How to embed a saved search in Obsidian](https://help.obsidian.md/Linking+notes+and+files/Embed+files#Embed+search+results)

## Quality of Life Improvements
There are a few plugins that can make working with links even easier: 

### Auto Link Title Plugin
Admittedly, it can be a bit tedious to write out a markdown link. We can make this so much easier. Simply install the [Auto Link Title](obsidian://show-plugin?id=obsidian-auto-link-title) plugin. Now you can simply paste a URL and Obsidian will automatically convert it into a markdown link. It will even fetch the title of the webpage and use that as the link text!

### Link Embed Plugin
But what if you would like a pretty preview of the webpage that you are linking to just like in Notion? Then you should install the [Link Embed](obsidian://show-plugin?id=obsidian-link-embed) plugin. This plugin will automatically embed a preview of the webpage that you are linking to. It will show the title, the description, and even a thumbnail of the webpage.

### Auto Embed Plugin
But sometimes we want an even more premium experience. We don't just want a generic preview of a link, but we want a custom preview for specific websites. That's where the [Auto Embed](obsidian://show-plugin?id=auto-embed) plugin comes in. This plugin adds support for embeds of Notion, Reddit, Mastodon and other sites. It will automatically fetch the content from the webpage and display it directly in your note.

## Conclusion
This is just a small taste of the power of links in Obsidian! As always, I want you to remember, don't feel like you have to use all of these features. Just use what works for you. But I hope that you have found something new and interesting in this post. If you have any questions or comments, please feel free to leave them below. I would love to hear from you.