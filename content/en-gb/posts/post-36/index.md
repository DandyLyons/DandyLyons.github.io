---
title: "Goodbye Dataview! Hello Obsidian Bases!"
description: Learn about the new Bases feature in Obsidian and how it makes Obsidian more powerful and easier to use.
date: 2025-05-24
tags: ["Obsidian", "Markdown", "WYSIWYG"]
topics: ["Bases", "Databases", "Dataview", "Markdown", "Obsidian", "YAML"]
slug: goodbye-dataview-hello-obsidian-bases
series: ["Actually Useful Obsidian"]
---
Obsidian has recently unveiled a game-changing native feature: **[Bases](https://help.obsidian.md/bases)**. If you've ever wished for Notion-like database capabilities within your Obsidian vault, but with the security of open, human-readable formats that won't lock you in, this is the update you've been waiting for. Bases, a new core plugin, is currently available for Catalyst members via early access (version 1.9.0 and above), and it's set to revolutionize how we organize and interact with information in Obsidian.

## A Brief History of Databases in Obsidian

To appreciate the significance of Bases, let's quickly look at how data management has evolved within Obsidian.

### Obsidian Databases: The Past

#### YAML Frontmatter

For years, [YAML frontmatter](https://notes.nicolevanderhoeven.com/obsidian-playbook/Using+Obsidian/03+Linking+and+organizing/YAML+Frontmatter) has been the quiet workhorse for metadata in Markdown files. This block of `key: value` pairs at the top of a note allows users to add structured information—like dates, tags, statuses, or custom fields—to their documents. It's a widely adopted standard and has served as the foundational data layer for many advanced Obsidian workflows.

```markdown
---
title: "A Brief History of Databases in Obsidian"
description: "Learn about the new Bases feature in Obsidian and how it makes Obsidian more powerful and easier to use."
date: 2025-05-24
topics: ["Bases", "Databases", "Dataview", "Markdown", "Obsidian", "YAML"]
draft: false
--- 
# A Brief History of Databases in Obsidian
This is the content of the note.
```

### Obsidian Databases: The Present

While YAML frontmatter provided the data, users needed ways to query and display it.

#### Dataview

The **[Dataview](https://blacksmithgu.github.io/obsidian-dataview/)** community plugin stepped up to fill this need, becoming incredibly popular. It allows users to query YAML frontmatter (and inline fields) from notes across their vault using its own Dataview Query Language (DQL). DQL is powerful and designed to be similar to SQL, enabling the creation of dynamic tables, lists, and summaries reminiscent of Notion databases.

````
```dataview
TABLE 
    FROM "Books"
    WHERE status = "read"
    SORT date DESC
```
````

This example shows how Dataview can create a table of all notes in the "Books" folder that have a status of "read," sorted by date in descending order. This is just a glimpse of what Dataview can do, as it supports complex queries, including filtering, sorting, and aggregating data.

However, Dataview comes with a learning curve. Its DQL syntax, while potent, is unique to Dataview. While it may be similar to SQL, there are major differences, so the skills don't readily transfer elsewhere. Queries can be brittle, breaking easily with syntax errors, and there's no [graphical user interface (GUI)](https://en.wikipedia.org/wiki/Graphical_user_interface) for building them. Furthermore, Dataview queries are not supported by [Obsidian Publish](https://obsidian.md/publish), limiting how users can share their structured data with others.

#### Obsidian Properties: Native GUI for Frontmatter

Recognizing the importance of structured data, Obsidian introduced the native **[Properties](https://help.obsidian.md/properties)** core plugin. This was a huge step forward, providing a user-friendly GUI for viewing and editing YAML frontmatter. No longer did users have to meticulously worry about correct YAML syntax; Properties handles it, even adding light type checking for data consistency. This made working with metadata much more accessible to everyone.

But Properties didn't just make it easier to edit YAML, it set the foundation for the next step in Obsidian's evolution: Bases. 

## Obsidian Databases: The Future (Bases Core Plugin)

The new **Bases** core plugin is the next logical leap. Just as Properties abstracted away the complexities of raw YAML, Bases aims to abstract away the complexities of query languages like DQL, offering a powerful, native, and GUI-driven way to create and manage databases within Obsidian. It's designed to turn any collection of notes into a dynamic database, perfect for organizing everything from projects and travel plans to reading lists and much more.

While Bases is still a work in progress and in an early access phase, its potential is immense.

### Using Views

At the heart of Bases are **Views**. These are different ways to display and interact with the data drawn from your notes.
- **Easy GUI Interface**: Creating and configuring views is done through a straightforward graphical interface, where actions are driven by clear buttons and menus—a welcome change from writing manual queries. This makes it a strong potential replacement for many common Dataview use cases.
- **Layouts**: Currently, Bases supports a **table layout**, where each row is a file and columns are populated from note properties. The roadmap promises more layouts, such as lists and cards, in the future.
- **Filtering**: You can easily filter the notes included in a view using a GUI. Filters allow you to narrow down results based on specific criteria (e.g., files with a certain tag, in a particular folder, or where a date property falls within a range). You can apply filters to all views in a base or to specific views.

### Embedding Views

Once you've created a base and its views, you can embed them directly into your notes:
- **Embed an Entire Base File**: Use the standard embed syntax `![[YourBaseFile.base]]`.
- **Embed a Specific Base View**: To display a particular **View** from your base by default, use the syntax `![[YourBaseFile.base#ViewName]]`.

### Using Functions

Bases includes a range of built-in functions that can be used in filters (to select which notes to include) and formulas (to create new, derived data columns from existing properties). These functions allow for sophisticated data manipulation and querying directly within the Bases UI or its underlying YAML definition.

Here are a few examples of helpful functions:
- **`contains(target, query)`**: Checks if a text property or list contains a specific string or item. Useful for filtering notes that mention a keyword or have a specific tag in a list.
- **`if(condition, value_if_true, value_if_false)`**: Allows for conditional logic in your formulas. For example, `if(property.status == "done", "Complete", "In Progress")`.
- **`dateAfter(date1, date2)`**: Checks if the first date is after the second. Excellent for time-sensitive data, like tasks due after a certain date.
- **`sum(property_name)`**: While more advanced aggregation and grouping features are on the roadmap, the table view already supports aggregation like `sum()`. In a view definition, you can specify `agg: "sum(price)"` to calculate the total of a 'price' property for grouped items, for instance. This is a key feature for creating summary dashboards.

### `.base` File Format

One of Obsidian's core strengths, and a major reason for its dedicated user base, is its commitment to open, user-owned data. Bases continues this tradition:
- **Open Technology Focus**: Obsidian prioritizes open, community-driven technologies like Markdown, YAML, and JSON, avoiding proprietary lock-in.
- **Transparent New Formats**: When a new feature requires a new format, Obsidian ensures it's human-readable and editable. The specification for the `.base` file is simple YAML with a defined schema. You can inspect it, edit it manually if you wish, and understand how your data is structured.
- **Future-Proofing**: Open formats are more likely to be compatible with future tools, including AI agents and other applications.
- **No Licensing Fees**: You own your data and the format it's stored in. You can edit your data in any app in a common text editor.
- **Open Sourcing**: Some formats, like the `.canvas` file format, are even open-sourced, further demonstrating this commitment.

The introduction of a new `.base` file format might initially raise concerns for some, myself included. I learned the hard way with Evernote how frustrating it can be to use a proprietary format. Companies use these formats to lock you into their ecosystem. You'd like to leave but you can't because your data is stuck in their system and is difficult or even impossible to export into another format.

Thankfully, Obsidian puts all of these fears to rest with the new `.base` file format. It's just a simple YAML text file, editable in any text editor, and it uses a simple human readable syntax which is [documented here](https://help.obsidian.md/bases/syntax). This file is used to define things like how you would like to sort or group results. These are many of the same things that we were already defining in Dataview DQL. The good news is that this means it should be quite easy to ask any high quality LLM (like chatGPT) to convert your old Dataview queries into new `.base` files.

Beyond the technical underpinnings, what truly makes Bases exciting is its accessibility.

## How to Get Started

My favorite part of this new feature is how trivially easy it is to get started. If you've already been adding Properties to your Obsidian notes then all you need to do is create a base and add a filter!

First we run the "Bases: Create new base" command. Now we immediately have a database with every single note in your entire vault. (My vault has over 3,400 notes. With Dataview, this query would slow my Obsidian to a crawl, but with Bases, it's no problem!) Now we have a powerful database without a strange query language to run. And every time that we make an edit in our database it will automatically update our human-readable `.base` file.

### Views
Obsidian not only created a *Base* for us, it created a *View*. Think of a Base like a collection of notes in your vault, and think of Views like a custom dashboard to view that collection of notes. You can make as many "dashboards" or Views as you like. At the moment, Obsidian only has one type of View a *Table*, but they have already announced in their [roadmap](https://help.obsidian.md/bases/roadmap) that they intend to add *Card* and *List* Views in the future.

Views can be renamed by clicking the View button, and choosing *Configure View*. Here we can also set a maximum number of results.

### Filtering
Now let's turn this into something a little more useful. In your new Obsidian **Base** there is a **Filters** button. Here are all of the familiar query GUI that you'd expect to see in an app like AirTable or Notion. We simply set a condition, and if a note meets that condition then it will kept by the filter, otherwise it will be removed. Don't forget Obsidian lets you apply a filter to just a specific View, or to every View in that Base.

### Properties
In our Table View we can click the *Properties* button. Here we see a list of every property that we've used across our whole Vault. We can type in and search for just the properties that we care about, and it will add that column to our Table.

### Editing
By far my favorite feature of this new Bases plugin is editing. Each cell in our Table is editable. Making a change in the cell, automatically updates the YAML frontmatter in that row's note! Dataview simply couldn't do this. It could fetch data, but it could not make changes. There's not much else to say about this feature. It just works exactly the way that you would hope it does.

## Still to Come: Bases Roadmap

The Bases plugin is still in its beta phase, with an extended early access period expected. Currently it's only accessible to users with a Catalyst license. The Obsidian team has an exciting roadmap for its development:
- **Bases API for Plugins**: This will allow other plugin developers to extend Bases with custom functions and new view types, potentially unlocking even more power.
- **More View Types**: Beyond the current table view, expect layouts like lists, cards, and potentially others.
- **Enhanced Grouping and Aggregation**: While some aggregation is present, more sophisticated grouping of files and a broader range of aggregation functions (like `average`, `count`) are planned.
- **Obsidian Publish support**: A crucial feature for many, this will allow users to publish their bases and share them on the web.

There are also some features that I'd like to see in the near future:
- An integrated search function within a Base View to quickly find specific entries without altering the main filters.

If Obsidian follows their past progress, then I'm confident that these features will come and the community will provide even more powerful community plugins to boot.

## Conclusion

For me, Obsidian Bases feels like the missing piece I've been waiting for. It elegantly solves the challenge of robust data management within my vault, moving beyond the limitations of past methods while upholding the open-data ethos that keeps me invested in Obsidian. The ease of getting started, combined with the power already evident and the exciting roadmap ahead, makes me incredibly optimistic. If you're a Catalyst member, I urge you to dive in; if not, keep a close eye on this space. Bases is set to redefine what's possible in Obsidian, and I can't wait to see how it, and our collective workflows, evolve.