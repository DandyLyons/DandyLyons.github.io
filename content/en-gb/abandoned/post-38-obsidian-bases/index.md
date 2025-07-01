---
title: "Obsidian Quick Tip: Folder Overviews with Obsidian Bases"
description: Learn about the new Bases feature in Obsidian and how it makes Obsidian more powerful and easier to use.
date: 2025-06-28
tags: ["Obsidian", "Markdown"]
topics: ["Bases", "Databases", "Dataview", "Markdown", "Obsidian", "YAML", "AirTable"]
slug: obsidian-bases-folder-overview
series: ["Obsidian Quick Tips"]
draft: true
---


## TLDR
**Just here for the quick tip? Here's all you need to know:**
Create a [Base](https://help.obsidian.md/bases) with the following filter: 

```yaml
filters:
  and:
    - file.folder == "Parent Folder Name"
views:
  - type: table
    name: Table
```

## What are Folder Overviews
Before I started using Obsidian, I was a big fan of Notion. It had a powerful notebook with connected notes and even a powerful database like AirTable, but alas I loved how Notion allows me to own my notes in simple local text files. I'll be frank though. For several years this was a major tradeoff. While Obsidian had many great advantages, I couldn't quite replicate all of my favorite features from Notion, at least not fully. Let's talk about two of those now: 

1. Interactive databases with a GUI (Graphical User Interface)
2. Folder notes: Hierarchical notes that can hold other notes.

### Interactive Databases
Obsidian recently released [Bases](https://help.obsidian.md/bases) now early release to paid Catalyst members. This new Core Plugin is a gigantic step toward the dream of bringing AirTable/Notion like databases to Obsidian. 

### Folder Notes
**What is a folder note?** Computers have long had the idea of files and folders. Files are your documents, data etc. and folders are little locations to hold your files. Just like a physical manila folder, you could put a folder inside another folder. This deeply nested structure of folders and files inside of other folders is a powerful method for organizing complex ideas. 

Both Notion and Obsidian have a concept of folders and files (notes), however Notion took a very unique approach. **In Notion, every note is a folder and vice versa.** It's difficult to explain why, but for some reason this mental model just clicked with me and I found myself missing it in Notion. While Obsidian, doesn't have this same mental model, Obsidian is so flexible that we can build something that works in a similar way. 

### Implementing Folder Notes in Obsidian
It wasn't long before the quest for folder notes became my white whale. Over time, I found many solutions, but all fell short of Notion for one reason or another. 

#### Using Folder Notes 
The Folder Notes community plugin attempts to recreate the way that Notion's sidebar navigator handles folders. When you click a folder, it opens that note (since every folder is a note). Using this plugin we can create a note in a folder, and, if the note meets the right conditions, then this plugin will cause it to behave like a Notion-style folder note. 

#### Using Dataview
Implementing a folder overview with Dataview is fairly straightforward. Just insert a code like this: 

````
```dataview
TABLE title
FROM "path/to/folder"
LIMIT 500
```
````

Now we have an auto-updating table which shows every file in this folder. Notice that I added `LIMIT 500`. This isn't necessary, but I do recommend it because Dataview can slow to a crawl when it has too many files. 

#### How to Get the Path of the Enclosing Folder
To get the path for your filter, use the Obsidian command "_Copy file path_" for any file within your target folder. This will give you a path like `path/to/folder/file.md`. Simply remove the filename (`/file.md`) to get the folder path (`path/to/folder`), which you can then use in your `.base` filter.

##### Problems with Dataview for Folder Overviews
Dataview was an invaluable tool in Obsidian for so very long, but it did have some major drawbacks: 
1. All changes must be made in Dataview's obscure DQL syntax. 
2. There are no simple buttons to change sorting order. 
3. If you have a massive list, you cannot further filter with a searchbar. Instead, you must edit the SQL syntax directly (plus you must remember to reverse the change after you are done). 
4. **Dataview does not paginate**: When we have a very long list of items[^&], we expect the list to have multiple pages instead of one massive unwieldy page. Dataview has no support for this. 
5. **Dataview is not interactive**: Dataview can display queries and that is it. Dataview does not allow you to edit any data from those queries. 

[^&]: for example, on every Google search we've ever had.
#### Exploring Other Folder Overview Plugins

Before the advent of Obsidian Bases, several community plugins aimed to bridge the gap in creating Notion-like database views and folder overviews within Obsidian. While innovative and highly useful in their time, these plugins often came with their own set of complexities or limitations that the native Bases core plugin now elegantly addresses.

##### DB Folder

The [DB Folder](https://rafaelgb.github.io/obsidian-db-folder/) plugin transformed folders of notes into Notion-like databases, allowing users to view and manage note metadata in structured tables, calendars, or Kanban boards. It leveraged Dataview for its query engine and offered features like customizable columns, live editing of metadata, and note creation directly from the database view. While powerful, its reliance on Dataview's DQL syntax and the need for manual configuration could be a barrier for some users.

##### Folder Notes by Lost Paul

The [Folder Notes](https://github.com/LostPaul/obsidian-folder-notes) plugin by Lost Paul aimed to replicate Notion's concept of a "folder note," where a note could also serve as an entry point for its containing folder. This allowed users to attach notes directly to folders and access them with a single click, streamlining navigation. While it provided a useful organizational paradigm, some users reported issues with template paths or general breakage after Obsidian updates, highlighting the challenges of maintaining complex community plugins.

##### Waypoint by Idrees

The [Waypoint](https://github.com/IdreesInc/Waypoint) plugin, developed by Idrees Hassan, focused on automatically generating dynamic tables of contents (Maps of Content or MOCs) within "folder notes." It ensured these lists updated automatically as files were created, renamed, or moved, and generated portable Markdown text. Waypoint was excellent for creating hierarchical overviews, but it primarily focused on linking and organization rather than the rich, interactive data management capabilities now offered by Bases.

With the introduction of Obsidian Bases, many of the functionalities provided by these individual plugins are now integrated into a native, more cohesive, and often more intuitive core feature. Bases offers a GUI-driven approach to filtering and managing notes, interactive editing, and a seamless experience that surpasses the combined efforts of these earlier solutions, making the process of creating powerful folder overviews significantly more accessible and robust.

### Modern Folder Notes in Obsidian
Now, let's look at how much better this can be in Bases. First let's find a folder that we'd like to create an overview for. We'll open the file explorer with the command _Files: Show file explorer_. Then find a folder and right click it. Look for the command named _New base_. This will create a new `.base` file in that folder. I recommend naming it the same name as the folder. This makes it clear that that Base will be an overview of everything in that folder. It also matches the naming scheme of your folder note. So you should have a file structure that looks something like this: 

- path/to/folder
  - folder.md
  - folder.base
  - other files.md

Now that we have a Base in the right location, let's get it set up. Open it and click the _Filter_ button. Don't forget that you can add a filter on the entire `.base` file, or you can apply a filter to only one particular view in the base. We're going to apply it to the whole `.base` file first by expanding _All views_. The first page in our query will say _All of the following are true_. 

Now we're ready to add our first condition, _where path contains path/to/folder_. Now, Obsidian will look through every file in your vault, and run a command `file.path`. This will return text with the location of that file on your computer's file storage. If the that includes the path that you input then it will be included in the database. So to get the path of the folder, we're going to use the exact same process that we used for the Dataview method. 

And there we have it, now we have an auto-updating list just like we had in Dataview, with a few key advantages: 

1. We never once had to use a strange syntax
2. We have a simple GUI interface
3. Now we can edit every file in our database directly inside of our `.base` file. Just like a Notion/Airtable-like database, we can type directly into our data cells which will immediately update that file! 

#### Embedding Our Database
It's worth reminding that this database can be easily embedded into any other note. Let's go into our folder note at `path/to/folder/folder.md`. Now, anywhere in the note we can insert the following: 

```markdown
![[folder.base]]
```



