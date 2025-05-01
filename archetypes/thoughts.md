---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
tags: 
    - thoughts # Default tag
slug: "{{ .Name | urlize }}"
aliases:
  # Alias for /thoughts/NUMBER/
  - "/thoughts/{{ .Name }}/"
  # Alias for /thoughts/SLUG/
  - "/thoughts/{{ .Name | urlize }}/"
description: # Add a short description of the post here. This will be used for SEO and social media sharing on Facebook, Twitter, etc. 
---

