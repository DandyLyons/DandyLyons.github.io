---
draft: false
build: 
  list: never
sitemap:
  disable: true
---

Open this file in the Obsidian vault in order to batch edit the metadata of all projects.

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
      - tags
      - slug
      - description
      - image
      - images
    columnSize:
      file.name: 51
      note.title: 304
      note.slug: 319
      note.description: 222
    rowHeight: medium

```
