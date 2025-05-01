---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
tags: 
    - essays # Default tag
slug: "{{ .Name | urlize }}"
aliases:
  # Alias for /essays/NUMBER/
  - "/essays/{{ .Name }}/"
  # Alias for /essays/SLUG/
  - "/essays/{{ .Name | urlize }}/"
---
