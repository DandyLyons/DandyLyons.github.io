---
title: "{{ .Name | humanize | title }}"
date: {{ .Date }}
draft: true
tags: 
    - "essays" {{/* 👈🏼 Default tag */}}
slug: "{{ .Name | urlize }}"
---
