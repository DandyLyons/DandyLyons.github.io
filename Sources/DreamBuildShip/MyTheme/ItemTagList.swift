import Plot
import Publish

struct ItemTagList<Site: Website>: Component {
  var item: Item<Site>
  var site: Site

  var displayedTags: [Tag] {
    item.tags.filter { tag in
      !tag.description.hasPrefix("hidden")
    }
  }
  
  var body: Component {
    List(displayedTags) { tag in
      Link(tag.string, url: site.path(for: tag).absoluteString)
    }
    .class("tag-list")
  }
}