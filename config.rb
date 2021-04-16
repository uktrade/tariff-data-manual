require 'govuk_tech_docs'
require_relative 'lib/dot'
require_relative 'lib/dbml'

GovukTechDocs.configure(self)

module RenderDotBlocks
  def block_code code, language
    if language =~ /dot/
      dot_to_svg code
    elsif language =~ /dbml/
      dbml_to_svg code
    else
      super code, language
    end
  end
end
GovukTechDocs::TechDocsHTMLRenderer.prepend(RenderDotBlocks)

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

configure :build do
  prefix = (ENV['GITHUB_REPOSITORY'] || '').partition('/')[-2..-1].join
  set :http_prefix, "#{prefix}/"
end
