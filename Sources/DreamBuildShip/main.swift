import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct DreamBuildShip: Website {
  enum SectionID: String, WebsiteSectionID {
    // Add the sections that you want your website to contain here:
    case blog
    case releases
  }
  
  struct ItemMetadata: WebsiteItemMetadata {
    // Add any site-specific metadata that you want to use here.
  }
  
  // Update these properties to configure your website:
  var url = URL(string: "https://dandylyons.github.io")!
  var name = "Dream. Build. Ship!"
  var description = "Welcome to my personal site."
  var language: Language { .english }
  var imagePath: Path? { nil }
  var favicon: Favicon? { nil }
  var twitterCard: TwitterCardType { .summary }
}

try DreamBuildShip()
  .publish(
    using: [
      .installPlugin(.splash(withClassPrefix: "")),

      .addMarkdownFiles(),
      .sortItems(in: .blog, by: \.date, order: .descending),
      
      .copyResources(),
      .generateHTML(withTheme: .myTheme, indentation: .spaces(2), fileMode: .foldersAndIndexFiles),
      
      .generateRSSFeed(including: [.blog], config: .default),
      .generateSiteMap(excluding: [], indentedBy: .spaces(2)),
      // Deployment step
      .deploy(using: .gitHub(
        "DandyLyons/DandyLyons.github.io",
        branch: "published",
        useSSH: true)
      )
    ]
  )




