---
draft: false
---

Open this file in the Obsidian vault in order to batch edit the metadata of all thoughts.

```base
filters:
  and:
    - file.folder.startsWith(this.file.folder)
    - file.ext == "md"
formulas:
  description: ""
views:
  - type: table
    name: Table
    order:
      - file.name
      - title
      - date
      - draft
      - tags
      - slug
      - description
      - image
      - images
    sort:
      - property: date
        direction: DESC
    columnSize:
      file.name: 51
      note.title: 241
      note.date: 224
      note.slug: 224
      note.description: 376
    rowHeight: medium

```
