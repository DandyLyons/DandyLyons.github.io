---
title: "{{ replaceRE `^[^-]+-(.+)` `$1` .Name | humanize | title }}" 
{{/* 👆🏼 title Extracts the portion of the filename after the first hyphen and converts it into title case.*/}}
date: {{ .Date }}
draft: true
tags: 
    - "thoughts" {{/* 👈🏼 Default tag */}}
slug: "{{ replaceRE `^[^-]+-(.+)` `$1` .Name | urlize }}" 
{{/* 👆🏼 slug Extracts the portion of the filename after the first hyphen and converts it into a URL-friendly format. */}}
aliases:
    - "/thoughts/{{ index (split .Name "-") 0 }}/" {{/* 👈🏼 Alias for /thoughts/NUMBER/ */}}
description: {{/* 👈🏼 description Add a short description of the post here. This will be used for SEO and social media sharing on Facebook, Twitter, etc.  */}}
---

