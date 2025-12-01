---
draft: false
build: 
  list: never
sitemap:
  disable: true
---
Open this file in the Obsidian vault in order to batch edit the metadata of all essays.

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
      - draft
      - date
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
      note.title: 304
      note.date: 193
      note.slug: 319
      note.description: 222
    rowHeight: medium

```
