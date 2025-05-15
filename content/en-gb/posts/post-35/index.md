---
date: 2025-05-14
title: "Smooth Site Migration: Redirecting GitHub Pages to Netlify Path-by-Path (with Hugo & SEO in Mind)"
slug: "smooth-site-migration-redirecting-github-pages-to-netlify-path-by-path"
tags: ["Hugo", "GitHub Pages", "Netlify", "SEO"]
images: [""]
description: "Migrating a website can be a bit like moving houses – exciting, but you still need to ensure everyone who knew your old address can find you at the new one."
topics: ["Hugo", "GitHub Pages", "Netlify", "SEO"]
---
Migrating a website can be a bit like moving houses – exciting, but you still need to ensure everyone who knew your old address can find you at the new one. When I recently moved my personal site from GitHub Pages (`dandylyons.github.io`) to Netlify (`dandylyons.net`), I faced this exact challenge. My old GitHub Pages site was still live, and simply letting it sit there wasn't ideal for users or search engine optimization (SEO).

The goal was clear: I needed to redirect visitors from `dandylyons.github.io` to `dandylyons.net`. But not just the homepage – I wanted to redirect specific paths. For example, `dandylyons.github.io/thoughts` should redirect to `dandylyons.net/thoughts`, `dandylyons.github.io/posts/my-post` should go to `dandylyons.net/posts/my-post`, and so on. This path-specific redirection is crucial for maintaining SEO link equity and providing a seamless experience for users who might have bookmarked deep links on the old site.

Complicating factors:
1. My site is built with **Hugo**, a static site generator.
2. I have a separate GitHub Pages site for notes at `dandylyons.github.io/notes`, which needed to remain untouched.
3. I wanted to preserve as much SEO value as possible.

Let's dive into how I tackled this, moving beyond a simple root redirect.

### The Initial Thought: A Simple Root Redirect

My first inclination was the simplest approach: just put a single HTML file at the root of the GitHub Pages site (`dandylyons.github.io`) that redirected everyone to the new homepage (`dandylyons.net`).

The HTML looked something like this, placed in an `index.html` file:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Redirecting...</title>
    <meta http-equiv="refresh" content="0;url=https://dandylyons.net">
    <link rel="canonical" href="https://dandylyons.net" />
  </head>
  <body>
    <p>You will be redirected to <a href="https://dandylyons.net">my new site</a> shortly.</p>
  </body>
</html>
```

I planned to serve this from the GitHub repository (`DandyLyons/DandyLyons.io`) that GitHub Pages uses for the root user site. This works for the homepage, but it has a major flaw: any request to a specific path on the old site (e.g., `dandylyons.github.io/thoughts`) would *also* land on this `index.html` and redirect to `dandylyons.net/`. This loses the specific path context, potentially breaking deep links and harming SEO by not directing search engines to the corresponding content on the new domain.

### The Refined Approach: Path-Specific Redirects for Static Sites

True path-by-path redirects are best handled with server-side 301 "Moved Permanently" redirects. This is the clearest signal to search engines that content has moved and they should transfer ranking signals to the new URL. However, GitHub Pages for user/organization sites (`username.github.io`) primarily serves static files directly from a repository branch (like `main` or `gh-pages`). You don't have server-level configuration options like `.htaccess` files to set up 301s easily for the root domain.

The most practical alternative for static hosting in this scenario is a client-side redirect combined with SEO-friendly tags. The meta refresh tag (`<meta http-equiv="refresh">`) can initiate an immediate redirect, and the `link rel="canonical"` tag can tell search engines which URL is the preferred version of the content.

To make this path-specific for every page of my Hugo site, I needed to generate the destination URL dynamically for each page's HTML file.

### Implementing Dynamic Redirects with Hugo

Since my site is built with Hugo, I could leverage its templating capabilities. I needed to modify the `<head>` section of my HTML layout to include the meta refresh and canonical tags, but have Hugo insert the correct *relative path* for each page.

Hugo provides the `.RelPermalink` variable, which gives the relative path from the root of the site to the current page (e.g., `/` for the homepage, `/thoughts/` for the thoughts index, `/posts/my-post/` for a specific post). I could combine this with the base URL of my new Netlify site (`https://dandylyons.net`) to construct the full destination URL for each redirect.

Here's the refined code I added to my Hugo `layouts/partials/head.html` (or a dedicated partial for this purpose):

```html
<head>
    {% comment %} This build is specifically for the GitHub Pages site (dandylyons.github.io) to redirect visitors to the new Netlify site (dandylyons.net), preserving paths. {% endcomment %}
    <title>Redirecting to dandylyons.net{{ .RelPermalink }}...</title>

    {{/* Construct the destination URL with the correct path */}}
    {{ $destinationURL := urls.JoinPath "https://dandylyons.net/" .RelPermalink }}

    {{/* Meta refresh for instant client-side redirect */}}
    <meta http-equiv="refresh" content="0;url={{ $destinationURL }}">

    {{/* Canonical tag pointing to the preferred (Netlify) URL for this specific path */}}
    <link rel="canonical" href="{{ $destinationURL }}" />

    {{/* ... Rest of your theme's original head content ... */}}

    {{/* IMPORTANT: Remove or comment out the original canonical tag that points to {{ .Permalink }} */}}
    {{/* <link rel="canonical" href="{{ .Permalink }}"> */}}

    {{/* ... More head content like RSS, styles, favicons, etc. ... */}}

</head>
```

**Key parts of the Hugo code:**

-  `{{ .RelPermalink }}`: Gets the relative path of the current page being built.
-  `urls.JoinPath "https://dandylyons.net/" .RelPermalink`: Safely joins the base Netlify URL with the relative path to create the full destination URL (e.g., `https://dandylyons.net/thoughts/`).
-  `content="0;url={{ $destinationURL }}"`: Creates an instant meta refresh redirect to the dynamically generated destination URL.
-  `<link rel="canonical" href="{{ $destinationURL }}" />`: Crucially, tells search engines that the Netlify URL (with the correct path) is the preferred version of this content.

**Important Note:** My theme's default `head.html` already included a canonical tag pointing to `{{ .Permalink }}`. When building for the *redirecting* GitHub Pages site, this tag would incorrectly point back to the GitHub Pages URL. I needed to remove or comment out this original canonical tag in the version of the `head.html` used for the GitHub Pages build to avoid conflicting signals.

### The Build and Deployment Strategy

Since my Hugo source is used to deploy *both* the redirecting GitHub Pages site and the main Netlify site, and they need different `<head>` content, I needed a strategy to manage this.

My workflow already used different branches for deployment:
1. Pushing to `deploy-netlify` triggered a build and deploy on Netlify.
2. Pushing to `deploy-gh-pages` triggered a build and deploy on GitHub Pages (`dandylyons.github.io`).

So I simply pushed one last commit to the `deploy-gh-pages` branch with the modified `head.html` containing the redirect logic. Now I just won't push any more changes to this branch, effectively freezing it in time. This way, the GitHub Pages site will always serve the redirect HTML with the correct path-based logic.

### Preserving the Notes Site and Existing Redirects

An important consideration was my separate notes site at `dandylyons.github.io/notes`. GitHub Pages serves user/organization sites (`username.github.io`) from a specific repository (like `DandyLyons/DandyLyons.io`) but can serve subdirectories from *other* repositories with matching names (like `DandyLyons/notes` for the `/notes` path).

The redirect we implemented is placed in the `DandyLyons/DandyLyons.io` repository and primarily affects the root domain and paths served from that repository. Because `dandylyons.github.io/notes` is served from the `DandyLyons/notes` repository, this redirect process *did not affect* the notes site. It remains functional.

Furthermore, I had an existing redirect configured on Netlify where `dandylyons.net/notes` redirects to `dandylyons.github.io/notes`. This Netlify-side configuration also remains untouched and continues to work as intended, sending visitors who try to reach the notes via my new domain back to the GitHub Pages version.

### SEO and Final Verification

While not a server-side 301, the combination of:

-  An immediate (`content="0"`) client-side meta refresh redirect,
-  Dynamically generated destination URLs preserving the path,
-  And a canonical tag on each redirecting page explicitly pointing to the new Netlify URL with the correct path

is a robust and SEO-conscious approach for this specific static hosting scenario. Search engines are generally good at understanding this pattern for site moves.

The final step was verification:

-  Browsing to `dandylyons.github.io/` correctly redirects to `dandylyons.net/`.
-  Browsing to `dandylyons.github.io/some-post/` correctly redirects to `dandylyons.net/some-post/`.
-  Browsing to `dandylyons.github.io/notes` still loads the notes site on GitHub Pages.
-  Browsing to `dandylyons.net/notes` still redirects back to `dandylyons.github.io/notes`.

### Conclusion

Migrating a static site from GitHub Pages to Netlify requires careful handling of redirects to ensure a smooth transition for users and search engines. While a true server-side 301 is ideal, implementing dynamic client-side meta refresh redirects with correct canonical tags via Hugo templating provides an effective path-by-path redirection method for static sites hosted on platforms like GitHub Pages where full server control isn't available. By isolating this redirect logic to the specific build deployed to the old domain's repository and freezing that branch, I successfully deprecated my old GitHub Pages site cleanly while maintaining SEO and preserving my separate notes site.

If you're facing a similar migration challenge with a static site generator, adopting a dynamic client-side redirect strategy tailored to your generator's templating capabilities is a powerful way to manage the transition gracefully.

