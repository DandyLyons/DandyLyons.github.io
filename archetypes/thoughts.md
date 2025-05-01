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
---

