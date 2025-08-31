---
title: "{{ replace .Name "-" " " | humanize | title }}"
slug: "{{ .Name | urlize }}"
date: {{ .Date }}
draft: true
build: 
  list: never
sitemap:
  disable: true
description: ""
author: "Your Name"
tags: 
    - programming # Default tag
categories: []
techstack: [] # Custom field for tech posts
---
<!-- Write your programming post here. -->

