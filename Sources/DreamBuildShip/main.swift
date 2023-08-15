import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct DreamBuildShip: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "DreamBuildShip"
    var description = "A description of DreamBuildShip"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
<<<<<<< HEAD
try DreamBuildShip().publish(withTheme: .foundation)
=======
//try DreamBuildShip().publish(withTheme: .foundation)

try DreamBuildShip()
  .publish(using: [
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .foundation),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),
    // Deployment step
    .deploy(using: .gitHub(
      "DandyLyons/DandyLyons.github.io",
      branch: "main",
      useSSH: true)
    )
    ])
>>>>>>> parent of e8f72bf (Publish deploy 2023-08-13 16:48)
