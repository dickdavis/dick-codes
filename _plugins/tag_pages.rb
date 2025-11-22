module Jekyll
  # Generator for creating individual tag pages
  class TagPageGenerator < Generator
    safe true

    def generate(site)
      return unless site.layouts.key? "tag"

      site.tags.each_key do |tag|
        site.pages << TagPage.new(site, site.source, tag)
      end
    end
  end

  # A Page subclass for tag pages
  class TagPage < Page
    def initialize(site, base, tag)
      @site = site
      @base = base
      @dir = File.join("tags", tag)
      @name = "index.html"

      process(@name)

      self.content = ""
      self.data = {
        "layout" => "tag",
        "tag" => tag,
        "title" => "Posts tagged with \"#{tag}\""
      }
    end
  end
end
