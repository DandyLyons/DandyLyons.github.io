---
title: "{{ .Name | humanize | title }}"
date: {{ .Date }}
draft: true
tags: 
    - "essays" {{/* 👈🏼 Default tag */}}
slug: "{{ .Name | urlize }}"
description: {{/* 👈🏼 description Add a short description of the post here. This will be used for SEO and social media sharing on Facebook, Twitter, etc.  */}}
---
