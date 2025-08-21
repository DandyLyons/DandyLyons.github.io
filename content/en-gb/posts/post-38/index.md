---
title: "How to Publish Unlisted Posts in Hugo"
date: 2025-08-18
draft: false
slug: "unlisted-posts-in-hugo"
description: "Sometimes you want to publish a blog post that's accessible via direct URL but doesn't appear in your site's normal navigation or discovery mechanisms. This guide shows you how to create unlisted posts in Hugo."
tags: ["Hugo", "Unlisted Posts", "SEO", "Web Development"]
---

# How to Publish Unlisted Posts in Hugo

Sometimes you want to publish a blog post that's accessible via direct URL but doesn't appear in your site's normal navigation or discovery mechanisms. This is useful for sharing draft content with specific people, creating landing pages, or publishing content that you want to keep semi-private.

When creating unlisted posts, you typically have four main concerns:

1. **Search Engine Visibility**: You don't want the post to appear in Google search results
2. **Sitemap Inclusion**: You don't want it listed in your sitemap.xml  
3. **RSS Feed Inclusion**: You don't want it appearing in your RSS feeds
4. **Site Listings**: You don't want it showing up on any list pages (homepage recent posts, category pages, tag pages, etc.)

Let's address each of these concerns systematically.

## 1. Preventing Search Engine Indexing

To prevent search engines from indexing your post, you'll need to add a custom parameter to your front matter and modify your site's head partial.

**Step 1: Add the unlisted parameter to your post's front matter:**

```yaml
---
title: "Your Hidden Post"
date: 2025-08-14
unlisted: true # This is a custom parameter defined by you which we will use later. 
---
```

**Step 2: Modify your head partial to check for this parameter.**

Find your head partial template (usually at `/layouts/partials/head.html` or `/themes/[theme-name]/layouts/partials/head.html`). If you're using a theme, copy the head partial from your theme to `/layouts/partials/head.html` to override it.

Add this code somewhere in your head partial:

```html
{{ if .Params.unlisted }}
<meta name="robots" content="noindex, nofollow">
{{ end }}
```

**What this does:** When Hugo processes a page with `unlisted: true` in the front matter, it will add `<meta name="robots" content="noindex, nofollow">` to the HTML `<head>`. The `noindex` directive tells search engines not to index the page (so it won't appear in search results), while `nofollow` tells them not to follow any links on the page for crawling purposes.

## 2. Excluding from Sitemap

Hugo provides built-in support for excluding pages from your sitemap. Simply add this to your front matter:

```yaml
sitemap:
  disable: true
```

This works automatically - no template modifications needed. Your post will no longer appear as an entry in your site's `sitemap.xml` file. This is important because search engines use sitemaps to discover and index pages on your website. By excluding your post from the sitemap, you're removing one of the primary ways search engines would find your unlisted content, even if they somehow discovered the URL through other means.

## 3. Excluding from RSS Feeds and All List Pages

Hugo provides a powerful built-in solution using the `build.list` parameter. Instead of using `list: false` (which many themes ignore), use:

```yaml
build:
  list: never
```

This tells Hugo to exclude the page from *all* page collections, including RSS feeds, homepage listings, section pages, taxonomy pages, and any other list context. The `build.list` parameter has three options:

- `always`: Include the page in all page collections (default)
- `local`: Include the page in local page collections only (useful for headless content sections)
- `never`: Do not include the page in any page collection (perfect for unlisted posts)

## Complete Front Matter Configuration

Here's the complete front matter setup for an unlisted post:

```yaml
---
title: "Your Hidden Post"
date: 2025-08-14
draft: false
unlisted: true
sitemap:
  disable: true
build:
  list: never
---
```

This configuration ensures your post is:
- Published and accessible via direct URL
- Hidden from search engines
- Excluded from your sitemap
- Removed from all site listings (homepage, RSS feeds, category pages, etc.)

## Testing Your Unlisted Post

To verify everything works correctly:

1. **Direct access**: Confirm the post is accessible via its direct URL
2. **Homepage**: Check that it doesn't appear on your homepage (if it shows recent posts)
3. **Section pages**: Verify it doesn't appear on relevant section pages (like `/posts/`)
4. **Sitemap**: Confirm it's not in your `sitemap.xml`
5. **RSS feeds**: Make sure it's not in your RSS feeds
6. **Search**: Verify it doesn't appear in your site's search results (if you have search functionality)

## Alternative: Using Different Content Types

If you prefer a completely separate approach, you can create unlisted posts as a different content type:

1. Create content at `/content/unlisted/my-post.md`
2. This creates a separate section that won't interfere with your main content
3. You can create custom templates at `/layouts/unlisted/single.html` if needed

## Key Takeaways

- Use a custom `unlisted: true` parameter and modify your head partial to add robots meta tags
- Use `build.list: never` for reliable exclusion from all listings  
- The `sitemap.disable` parameter works automatically without modifications
- Only the robots meta tag requires a template change - everything else is built into Hugo
- Always test your unlisted posts across all areas of your site

With Hugo's built-in `build` and `sitemap` options plus a simple head partial modification, creating truly unlisted posts is straightforward and reliable.