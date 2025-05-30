---
title: Migrating Notes from Hugo/Quartz to Obsidian Publish
date: 2025-05-30
tags: [obsidian, netlify, migration, quartz, publish]
description: |
  A detailed guide on migrating notes from Hugo/Quartz to Obsidian Publish, leveraging Netlify for seamless integration under a custom domain.

---
# Migrating Notes from Obsidian Quartz to Obsidian Publish, Seamlessly Integrated with Netlify

It's no secret that I am a very big fan of Obsidian. I use it for everything from note-taking to project management, and even as a publishing platform for my notes. In order to publish notes on the web, Obsidian offers [Obsidian Publish](https://obsidian.md/publish), a service that allows you to host your notes as a static website. However, I had been using [Obsidian Quartz](https://quartz.jzhao.xyz/) for my publishing needs. I liked it primarily because it was free and open source, and I could host it myself on GitHub Pages. However, I found that the publishing workflow was a bit cumbersome. So I finally decided to migrate my notes from Obsidian Quartz to Obsidian Publish, while still keeping them under my main website (`dandylyons.net`) using Netlify as a proxy.

This post will walk through the migration process, the technical details of integrating Obsidian Publish with my existing Hugo site, and the key considerations for SEO and user experience.

## Choosing Obsidian Publish: Quartz vs. Publish

Understanding the difference between Obsidian Quartz and Obsidian Publish is key to appreciating the migration path. Both take an Obsidian vault as input and produce a static website, but their architecture and hosting differ significantly.

| Feature                 | Obsidian Quartz (Community SSG)                                                             | Obsidian Publish (Official SSG/Hosting Service)                                                      |
| :---------------------- | :------------------------------------------------------------------------------------------ | :--------------------------------------------------------------------------------------------------- |
| **Type**                | Standalone Static Site Generator (open source)                                              | Integrated Static Site Generator & Hosting Service (closed source, paid)                             |
| **Development**         | Community-driven, open source                                                               | Developed and maintained by Obsidian.md team                                                         |
| **Cost**                | Free (plus your hosting costs)                                                              | Paid Subscription (required for the service)                                                         |
| **Hosting**             | Self-hosted (You deploy the generated site to platforms like Netlify, Vercel, GitHub Pages) | Hosted directly by [Obsidian](https://publish.obsidian.md)                                           |
| **Setup Complexity**    | Requires installing Quartz, running the build process, configuring deployment to a host     | Configuration primarily within the Obsidian app; less external setup; less technical skills required |
| **Customization**       | Highly customizable (modify templates, CSS, etc.)                                           | Highly customizable (CSS, Javascript)                                                                            |
| **Publishing Workflow** | Run Quartz build -> Deploy generated files                                                  | Publish directly from within the Obsidian app                                                        |
| **Features**            | Often replicates Obsidian features like graph view, backlinks via generation                | Built-in graph view, backlinks, version history, password protection                                 |

### Pros and Cons
| Tool             | Pros                                                                                                                               | Cons                                                                                                                                                              |
| :--------------- | :--------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Obsidian Quartz  | - Free and open source<br>- Provides full control over the static site generation process and generated files<br>- High degree of customization through template and asset modification<br>- You choose and control your hosting environment | - Requires a separate build process and deployment workflow outside of Obsidian<br>- Updates require running the build and redeploying<br>- Relies on community development for features and updates |
| Obsidian Publish | - Extremely easy publishing workflow directly from the Obsidian app<br>- Fully managed hosting by Obsidian.md – no build pipelines or server maintenance<br>- Official support and tightly integrated features (versioning, etc.) | - Paid subscription is required<br>- Less flexibility and customization compared to a standalone SG<br>- You have less control over the hosting environment and generated files |


For my notes, the 'zero-friction' publishing directly from Obsidian and the managed hosting of Obsidian Publish became more appealing, justifying the shift despite Quartz's strengths as a free solution. But these benefits have been true for a while now. So what caused me to finally make the switch? [Bases](https://help.obsidian.md/bases). I have been waiting for the Obsidian team to release a database solution for Obsidian for a very long time, and I was [stoked to see that they finally did](https://dandylyons.net/posts/goodbye-dataview-hello-obsidian-bases/). Even better, they announced in their [roadmap](https://help.obsidian.md/bases/roadmap) that Obsidian Publish would support Bases in the future. As much as I like and appreciate Obsidian Quartz, I doubt that a third-party community project will ever be able to match the level of integration and support that Obsidian Publish will provide for Bases. This will certainly be a game-changer for my notes, and I wanted to be ready for it. So I decided to migrate my notes from Obsidian Quartz to Obsidian Publish.

## The Migration Strategy: Netlify as the Integration Layer

Obsidian has very helpful [documentation showing how to set up Obsidian Publish with a custom domain](https://help.obsidian.md/publish/domains), which I used for this migration.

My main website (`dandylyons.net`), built with Hugo, was already hosted on Netlify. The challenge was to move the *notes content* to the Obsidian Publish service while still having it appear as part of `dandylyons.net` under the `/notes/` path.

[Once again](http://dandylyons.net/posts/smooth-site-migration-redirecting-github-pages-to-netlify-path-by-path/) Netlify's [redirect engine](https://docs.netlify.com/routing/redirects/) is the key here. It allows Netlify to act as a **proxy**. When a user requests a URL under `dandylyons.net/notes/`, Netlify intercepts the request and *internally* fetches the corresponding content from the Obsidian Publish hosted site, serving it back to the user as if it originated from `dandylyons.net`.

This setup is ideal:
- My main Hugo site handles all requests *except* those starting with `/notes/`.
- Obsidian Publish generates and hosts the notes content.
- Netlify bridges the two, presenting the notes content under the desired `dandylyons.net/notes/` path.
- When a user requests a URL under `dandylyons.net/notes/`, Netlify intercepts the request and fetches the corresponding content from the Obsidian Publish hosted site, serving it back to the user as if it originated from `dandylyons.net`.

## Implementing the Proxy with `netlify.toml`

To configure redirects on Netlify, you must provide a `netlify.toml` file in the root of your project, with the desired configuration. My Netlify project for `dandylyons.net` already had a `netlify.toml` file managing the Hugo build which contained an outdated redirect rule pointing `/notes/*` to my old GitHub Pages hosted Quartz site. This rule needed to be replaced with the new proxy rule for Obsidian Publish.

Here is the relevant section of the updated `netlify.toml`:

```toml
[build.environment]
HUGO_VERSION = "0.134.0" # Set this to your Hugo version

[[redirects]]
  from = "/notes/*"
  to = "https://publish.obsidian.md/serve?url=dandylyons.net/notes/:splat"
  status = 200 # Crucially, status 200 creates a proxy/rewrite, not a redirect
  force = true # Ensures this rule takes precedence

# This was my old redirect rule, which is now commented out
# [[redirects]]
#   from = "/notes/*"
# to = "https://dandylyons.github.io/notes/:splat" # Old URL
# status = 301
# force = true
```

### How the Proxy Rule Works (`status = 200`)

When a browser requests `https://dandylyons.net/notes/some-page`:
1. The request arrives at Netlify for `dandylyons.net`.
2. Netlify matches the `/notes/*` path to the `[[redirects]]` rule.
3. Because `status = 200`, Netlify does *not* tell the browser to go to a new URL.
4. Instead, Netlify makes a server-side request to the `to` URL: `https://publish.obsidian.md/serve?url=dandylyons.net/notes/some-page` (where `:splat` was replaced by `some-page`).
5. Obsidian Publish receives this request, identifies the site based on `dandylyons.net/notes`, finds the "some-page" content, and returns it to Netlify.
6. Netlify then delivers that content back to the user's browser, seemingly originating from `https://dandylyons.net/notes/some-page`.

The URL in the browser's address bar remains `https://dandylyons.net/notes/some-page`. This is exactly the desired behavior for integrating content under a subpath.

## Configuring Obsidian Publish & Updating Hugo

With the Netlify proxy configured, the final steps involve setting up Obsidian Publish and adjusting the main Hugo site:

1. **Configure Custom Domain in Obsidian Publish:** Within your Obsidian vault, access the Publish settings. Under the Custom domain option, enter `dandylyons.net/notes` as the custom URL for your published site. This setting is essential for Obsidian Publish to correctly interpret the requests arriving via the Netlify proxy.
2. **Update Hugo Site Links:** Modify your Hugo project's `config.toml` and any markdown files. Change any links that pointed to your old Quartz site URL (e.g., `https://dandylyons.github.io/notes/...`) to now point to the new internal path `/notes/...`. This includes updating the "Notes" menu item in your site's navigation.

## Key SEO Considerations

Migrating content from one hosting/generating method to another, especially involving a proxy, requires careful attention to SEO to preserve search rankings and user experience. Thankfully, Obsidian Publish also provides some built-in SEO features and an [SEO guide](https://help.obsidian.md/publish/seo). Here are some of the key SEO features provided by Obsidian Publish: 

- **Sitemap:** Obsidian Publish can automatically generate a `sitemap.xml` for you
- **Robots.txt:** Obsidian Publish can automatically generate a `robots.txt` file for you
- **RSS:** Obsidian Publish can automatically generate an RSS feed for you

Here are some additional SEO considerations to ensure a smooth transition:
- **Internal Linking:** Update *all* internal links within your main Hugo site (`/posts/`, `/projects/`, etc.) to correctly point to the new `/notes/` paths. This is fundamental for SEO, helping search engines discover the migrated content's new location and pass link authority.
- **External Backlinks:** Identify any valuable external links pointing to your old Quartz site's URL (e.g., `https://dandylyons.github.io/notes/...`). While you could try basic redirects on the old host (if possible), the most effective long-term strategy for important backlinks is to contact the linking site owners and ask them to update the URL to `https://dandylyons.net/notes/...`.
- **Sitemaps:** Your Hugo site generates a sitemap (`sitemap.xml`) for its content. Obsidian Publish generates a sitemap for the notes content. **Submit *both* sitemaps** to Google Search Console under your `dandylyons.net` property. This ensures search engines are aware of all content under your consolidated domain.
- **Robots.txt:** Your main Hugo site's `robots.txt` file (usually in the `static` directory) governs crawling for the entire `dandylyons.net` domain. 

By diligently addressing these SEO points, you can ensure a smoother transition in search engine visibility and maintain the discoverability of your notes content.

## Conclusion

By migrating my notes from Obsidian Quartz to Obsidian Publish I've made it much easier to manage and publish my notes. And now with Netlify redirecting requests, I can keep the notes under my main domain (`dandylyons.net/notes/`), providing a seamless experience for users.

