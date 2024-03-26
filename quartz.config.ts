import { QuartzConfig } from "./quartz/cfg"
import * as Plugin from "./quartz/plugins"

/**
 * Quartz 4.0 Configuration
 *
 * See https://quartz.jzhao.xyz/configuration for more information.
 */
const config: QuartzConfig = {
  configuration: {
    pageTitle: "Dream. Build. Ship!",
    enableSPA: true,
    enablePopovers: false,
    analytics: {
      provider: "plausible",
    },
    locale: "en-US",
    baseUrl: "dandylyons.github.io",
    ignorePatterns: ["private", "templates", ".obsidian"],
    defaultDateType: "created",
    theme: {
      fontOrigin: "googleFonts",
      cdnCaching: true,
      typography: {
        header: "Schibsted Grotesk",
        body: "Source Sans Pro",
        code: "IBM Plex Mono",
      },
      colors: {
        lightMode: {
          light: "#faf8f8", // page background
          lightgray: "#e5e5e5",// inline code background, searchbox background
          gray: "#b8b8b8", // date, metadata
          darkgray: "#4e4e4e",// copy text, search bar, darkmode
          dark: "#17a806", // headings
          secondary: "#284b63", // site title, link (no hover)
          tertiary: "#84a59d", // graph node sibling, link (hover)
          highlight: "rgba(50, 255, 9, 0.15)",
        },
        darkMode: {
          light: "#090b08", // page background
          lightgray: "#0e150d", // inline code background, searchbox background
          gray: "#4d794a", // date, metadata
          darkgray: "#eeeff0", // copy text, search bar, darkmode
          dark: "#446d3d", // headings
          secondary: "#45ba24", // site title, link (no hover)
          tertiary: "#64f02b", // graph node sibling, link (hover)
          highlight: "rgba(10, 140, 58, 0.15)",
        },
      },
    },
  },
  plugins: {
    transformers: [
      Plugin.FrontMatter(),
      Plugin.CreatedModifiedDate({
        priority: ["frontmatter", "filesystem", "git"],
      }),
      Plugin.Latex({ renderEngine: "katex" }),
      Plugin.SyntaxHighlighting({
        theme: {
          light: "github-light",
          dark: "github-dark",
        },
        keepBackground: false,
      }),
      Plugin.ObsidianFlavoredMarkdown({ enableInHtmlEmbed: false }),
      Plugin.GitHubFlavoredMarkdown({linkHeadings: true, enableSmartyPants: true}),
      Plugin.HardLineBreaks(),
      Plugin.TableOfContents({collapseByDefault: true, showByDefault: true}),
      Plugin.CrawlLinks({ 
        markdownLinkResolution: "shortest" ,
        openLinksInNewTab: true,
        lazyLoad: true,
      }),
      Plugin.Description(),
    ],
    filters: [Plugin.ExplicitPublish()], // only publish files that have the "publish: true" frontmatter 
    emitters: [
      Plugin.AliasRedirects(),
      Plugin.ComponentResources(),
      Plugin.ContentPage(),
      Plugin.FolderPage(),
      Plugin.TagPage(),
      Plugin.ContentIndex({
        enableSiteMap: true,
        enableRSS: true,
        includeEmptyFiles: false,
        rssFullHtml: true,
        
      }),
      Plugin.Assets(),
      Plugin.Static(),
      Plugin.NotFoundPage(),
    ],
  },
}

export default config
