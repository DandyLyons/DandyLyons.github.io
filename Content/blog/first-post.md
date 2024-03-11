---
date: 2023-08-13 16:39
description: This is the beginning of my personal site.
tags: announcement
---
# Welcome to Dream. Build. Ship!

Hello and welcome to my personal site. Here I will be sharing anything that I find interesting, including [apps that I'm developing](/tags/app) and [general thoughts that I want to share with the world](/blog).



```
let string = "hello world"
```

```swift
struct MyHTMLFactory<Site: Website>: HTMLFactory {

  // The front page of the website.
  func makeIndexHTML(for index: Index,
                     context: PublishingContext<Site>) throws -> HTML {
    let latestContentItems = context
      .allItems(sortedBy: \.date, order: .descending)
      .filter { (item: Item<Site>) in
        item.tags.allSatisfy { $0.description != "hidden" } }

    return HTML(
      .lang(context.site.language),
      .head(for: index, on: context.site),
      .body {
        SiteHeader(context: context, selectedSelectionID: nil)
        Wrapper {
          H1(index.title)
          // Paragraph(context.site.description)
          //   .class("description")
          H2("Latest content")
          ItemList(
            items: latestContentItems,
            site: context.site
          )
        }
        SiteFooter()
      }
    )
  }
  
  // The root level "index" page of each section.
  func makeSectionHTML(for section: Section<Site>,
                       context: PublishingContext<Site>) throws -> HTML {
    let items = section.items
      .filter { $0.tags.allSatisfy { $0.description != "hidden-\(section.id)" } }

    return HTML(
      .lang(context.site.language),
      .head(for: section, on: context.site),
      .body {
        SiteHeader(context: context, selectedSelectionID: section.id)
        Wrapper {
          H1(section.title)
          ItemList(items: items, site: context.site)
        }
        SiteFooter()
      }
    )
  }
  
  // The "detail" page for each item.
  func makeItemHTML(for item: Item<Site>,
                    context: PublishingContext<Site>) throws -> HTML {
    HTML(
      .lang(context.site.language),
      .head(for: item, on: context.site),
      .body(
        .class("item-page"),
        .components {
          SiteHeader(context: context, selectedSelectionID: item.sectionID)
          Wrapper {
            Article {
              Div(item.content.body).class("content")
              if item.tags.displayableTags.isEmpty == false {
                Span("Tagged with: ")
                ItemTagList(item: item, site: context.site)
              }
            }
          }
          SiteFooter()
        }
      )
    )
  }
  
  func makePageHTML(for page: Page,
                    context: PublishingContext<Site>) throws -> HTML {
    HTML(
      .lang(context.site.language),
      .head(for: page, on: context.site),
      .body {
        SiteHeader(context: context, selectedSelectionID: nil)
        Wrapper(page.body)
        SiteFooter()
      }
    )
  }
  
  func makeTagListHTML(for page: TagListPage,
                       context: PublishingContext<Site>) throws -> HTML? {
    HTML(
      .lang(context.site.language),
      .head(for: page, on: context.site),
      .body {
        SiteHeader(context: context, selectedSelectionID: nil)
        Wrapper {
          H1("Browse all tags")
          List(page.tags.sorted()) { tag in
            ListItem {
              Link(tag.string,
                   url: context.site.path(for: tag).absoluteString
              )
            }
            .class("tag")
          }
          .class("all-tags")
        }
        SiteFooter()
      }
    )
  }
  
  func makeTagDetailsHTML(for page: TagDetailsPage,
                          context: PublishingContext<Site>) throws -> HTML? {
    HTML(
      .lang(context.site.language),
      .head(for: page, on: context.site),
      .body {
        SiteHeader(context: context, selectedSelectionID: nil)
        Wrapper {
          H1 {
            Text("Tagged with ")
            Span(page.tag.string).class("tag")
          }
          
          Link("Browse all tags",
               url: context.site.tagListPath.absoluteString
          )
          .class("browse-all")
          
          ItemList(
            items: context.items(
              taggedWith: page.tag,
              sortedBy: \.date,
              order: .descending
            ),
            site: context.site
          )
        }
        SiteFooter()
      }
    )
  }
}
```