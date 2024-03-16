import { PageLayout, SharedLayout } from "./quartz/cfg"
import * as Component from "./quartz/components"

// components shared across all pages
export const sharedPageComponents: SharedLayout = {
  head: Component.Head(),
  header: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Search(),
    Component.Darkmode(),
  ],
  footer: Component.Footer({
    links: {
      GitHub: "https://github.com/DandyLyons",
      "X (Twitter)": "https://twitter.com/dan_dee_lyons",
      "Mastodon": "https://iosdev.space/@dandylyons",
      "LinkedIn": "https://www.linkedin.com/in/dandylyons/",
    },
  }),
}

// components for pages that display a single page (e.g. a single note)
export const defaultContentPageLayout: PageLayout = {
  beforeBody: [
    Component.Breadcrumbs(),
    Component.ArticleTitle(),
    Component.ContentMeta(),
    Component.TagList(),
  ],
  left: [
    // Component.PageTitle(),
  ],
  right: [
    Component.Graph(),
    Component.Explorer({
      folderClickBehavior: "link",
      folderDefaultState: "open",
      useSavedState: true,
    }),
    Component.TableOfContents(),
    Component.Backlinks(),
  ],
}

// components for pages that display lists of pages  (e.g. tags or folders)
export const defaultListPageLayout: PageLayout = defaultContentPageLayout
