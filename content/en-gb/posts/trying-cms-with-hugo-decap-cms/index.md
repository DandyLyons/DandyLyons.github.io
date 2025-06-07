---
title: "Trying CMS with Hugo: Decap CMS"
date: 2025-06-07T17:10:00.000Z
draft: true
slug: trying-cms-with-hugo
description: "Learning how to use Decap CMS with Hugo. "
author: Daniel Lyons
tags:
  - programming
---
I've been running this personal site a little over a year[^d]. I've enjoyed using Hugo. It's fast, markdown based, and I'm not locked in to any vendor. 👍🏼
But it's been a bit tedious to release new posts. Currently, I write directly to markdown and push changes to Netlify for deployment. This process works well enough but a small part of me misses the usability of a WYSIWYG editor. This is where a CMS comes in.

[^d]: (\*checks date), yup, since March of 2024, so just over a year.

## CMS: Content Management System

To recall, Hugo is a static-site-generator. It takes simple markdown text files, and renders them into full websites with HTML and CSS. This is a fantastic solution for developing a site, but isn't necessarily the best solution for creating content on a site. Many content creators, such as blog writers don't want to deal with the complexity of syntaxes (even one as simple and lightweight as Markdown). They just want to focus on content! That's where a CMS comes in.
A content management system, provides a simple approachable GUI to create, edit, and post content. In other words, you can run a website, without needing to understand the full complexity of HTML, Javascript, CSS, git, CI/CD etc.

## Wearing Separate Hats

But I understand HTML etc. I am a developer. So why do I need a CMS then? The truth is, I don't. I can do all of this without a CMS and I have been for a year now. But I suspect it might remove some friction for me[^1]. The main reason why I'm interested in a CMS is so that I can separate development (deploying, theme configuration, and other technical tasks) from content work (writing, editing etc.). These tasks require separate parts of my brain. They also are largely unrelated from each other so it doesn't make a ton of sense to mix them together in my git history. If I need to roll back a development change, why should that roll back a new post? I hope that after using a CMS it will be easier to keep these things separated for me.

[^1]: Though, I'll admit it could just add more complexity as well.

## Remote Posting

If I want to post to Medium, I just log into Medium and start writing. I don't have to open VS Code. I don't have to set up a development environment. I can post something quick from my phone. I can even post from any device at all, as long as I log in.
But right now, if I want to post to my Hugo site, I have to open an IDE. I need to have the repo downloaded on the machine. I have to have Hugo installed on that machine. None of these, are that big of a deal in isolation, but together these paper cuts add up and they make me less likely to be motivated to be creative and write.

## Headless CMS with Hugo: The Best of Both Worlds?

So now you can see the headspace I was in when I decided to look for a CMS solution for my Hugo site. In my initial research, I learned that what I wanted was something called a Git-backed headless CMS. We defined CMS. Let's define some more terms:

### Git-Backed

All of the data for your site (content and development) is stored in the git history. I like this because it matches how I was already using Hugo.

### headless

A headless CMS is a system that separates the back-end (where content is created, stored, and managed) from the front-end (where content is displayed, such as on a website, mobile app, or other digital channels). In our case, what that means is, it will only handle the content, but it won't care about how that content is rendered. Instead it will let someone else handle that (in our case, Hugo).

## DecapCMS

After some searching, it seems like Decap is my favorite solution that I found so far. Here's the basic mental model:
*   Hugo is generating a site from Markdown files exactly the same as it was before (in fact, Hugo is unaware of Decap).
*   To use Decap you simply go to `<yoursite.com>/admin`. This will load the Decap editing interface.
*   Decap is simply a UI that makes it easier to create and edit files without being distracted by technical details.
*   When you save a change in Decap then Decap will directly make this change in your git repo. There are two ways that Decap can do this:
    *   If you are editing locally, then Decap can edit your site's files in place on your computer.
    *   If you are editing online, then saving Decap will cause Decap to remotely commit a change to your GitHub repo, which can then later be built by Hugo and deployed to your host.

Thankfully this wasn't very complex to set up at all. I just followed Decap's guide on Installing Decap CMS and Integrating Decap to work with Hugo.

## Authentication

In order for Decap to work properly it has to authenticate users. After all we wouldn't want just anyone to edit your site, right? Well this leads me to a little detail that I'd like to call out.
It's worth briefly highlighting a bit about Decap's history. Decap used to be owned by Netlify and named Netlify CMS. Netlify has since open sourced it and so it has been renamed Decap.
Likewise, Decap relies on some service to authenticate users. Thankfully, Decap is very flexible and allows you to choose your own auth vendor, but clearly the simplest solution that the docs point to is Netlify Identity. There's only one problem: Netlify has deprecated Netlify Identity. So at the moment, I'm using Netlify Identity to auth (and it works great), but I do plan to migrate to DecapBridge in the near future.

## What It's Like Using Decap

Decap is a bit of a mixed bag, for me at the moment. The writing editor is not great. Certain markdown features are not implemented. For example, footnotes have no GUI button and straight up do not render in the preview editor. Decap also has a Rich Text editor but I've stopped liking those. I can type markdown syntax faster than I can click a button and return my hands back to the keyboard. I'm almost certain that I won't be writing posts on Decap unless I'm posting from my phone. The nice thing about markdown is I can edit in any markdown editor for the best writing experience. When I'm ready, "importing" my content is as simple as pasting it in.
But there are two big benefits that I'm enjoying out of Decap so far:
*   **Easy Post Creation**: Decap makes it easy to start a post. I pick the type of post and Decap will create a new file in the correct directory and include all the metadata in my YAML header to match the schema for that type of post! 🎉
*   **Remote Content Management**: Decap makes it possible to draft, edit, and post content remotely.

## Further Exploration

Decap has a feature it calls Workflows. Workflows allow you to:

*   **Track Status**: keep track of the status of posts by marking them as Draft, In Review, or Ready.
*   **Deploy Preview Links**: Deploy Preview Links so that you can show unpublished content to stakeholders. 

## Handling Media

My media needs are simple, mostly just the occasional picture in a blog post. Currently I'm hosting media directly inside my content files which Hugo makes pretty easy, but I've learned is not such a great idea because it could lead to a colossal bill from your host. Thankfully, Decap has some tools that should make this easier.


I need to look into these features more in the future to see if they'd be a good fit for me.

