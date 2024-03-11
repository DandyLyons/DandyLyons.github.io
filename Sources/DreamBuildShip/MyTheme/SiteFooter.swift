import Foundation
import Plot

public struct SiteFooter: Component {
  public var body: Component {
    Footer {
      Paragraph {
        Text("Copyright © Daniel Lyons \(String(Date().formatted(.dateTime.year())))")
      }
      Paragraph {
        Text("Built in ")
        Link("Swift", url: "https://www.swift.org/")
        Text(" using ")
        Link("Publish.", url: "https://github.com/johnsundell/publish")
//        Link("RSS feed", url: "/feed.rss")
      }
    }
  }
}