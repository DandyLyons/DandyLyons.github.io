
import Plot
import Publish

struct SiteHeader<Site: Website>: Component {
  var context: PublishingContext<Site>
  var selectedSelectionID: Site.SectionID?
  
  var body: Component {
    Header {
      Wrapper {
        Link(context.site.name, url: "/")
          .class("site-name")
        
        if Site.SectionID.allCases.count > 1 {
          navigation
        }
      }
    }
  }
  
  var navigation: Component {
    Navigation {
      List(Site.SectionID.allCases) { sectionID in
        let section = context.sections[sectionID]
        
        return Link(section.title,
                    url: section.path.absoluteString
        )
        .class(sectionID == selectedSelectionID ? "selected" : "")
      }
    }
  }
}