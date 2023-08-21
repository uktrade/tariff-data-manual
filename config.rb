require 'uri'
require 'govuk_tech_docs'
require_relative 'lib/dot'
require_relative 'lib/dbml'
require_relative 'lib/tariffsql'

GovukTechDocs.configure(self)

module RenderCodeBlocks
  def block_code code, language
    if language =~ /dot/
      dot_to_svg code
    elsif language =~ /dbml/
      dbml_to_svg code
    elsif language =~ /sql/
      sql_to_table code
    else
      super code, language
    end
  end
end
GovukTechDocs::TechDocsHTMLRenderer.prepend(RenderCodeBlocks)

module EmbedSVG
  def image link, title, alt
    if link =~ /^images\/.*\.svg$/
      svg = File.read(File.join "source", link)
      code = /<svg.*<\/svg>/m.match(svg)[0]
      code.insert(4, " aria-label=\"#{alt.gsub('"', '&quot;')}\"")
    else
      super link, title, alt
    end
  end
end
GovukTechDocs::TechDocsHTMLRenderer.prepend(EmbedSVG)

module RetargetLinks
  def link link, title, content
    if link.nil?
      super link, title, content
    else
      uri = URI::parse link
      if uri.relative? && uri.path =~ /\.md$/
        uri.path = PREFIX + "/documentation/" + uri.path.downcase.gsub(/;-/, '/').gsub(/\.md$/, '.html')
      end
      super uri.to_s, title, content
    end
  end
end
GovukTechDocs::TechDocsHTMLRenderer.prepend(RetargetLinks)

PREFIX = (ENV['GITHUB_REPOSITORY'] || '').partition('/')[-2..-1].join

configure :build do
  set :http_prefix, "#{PREFIX}/"
end
