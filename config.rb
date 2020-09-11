require 'govuk_tech_docs'

GovukTechDocs.configure(self)

module RenderDotBlocks
  DOT_ARGS = [
    '-Tsvg',
    '-Nfontname=Arial'
  ]

  def block_code code, language
    if language =~ /dot/
      svg = IO.popen(['dot', *DOT_ARGS], mode: 'r+') do |dot|
        dot.write code
        dot.close_write
        dot.read
      end
      /<svg.*<\/svg>/m.match(svg)[0]
    else
      super code, language
    end
  end
end
GovukTechDocs::TechDocsHTMLRenderer.prepend(RenderDotBlocks)

configure :build do
  prefix = (ENV['GITHUB_REPOSITORY'] || '').partition('/')[-2..-1].join
  set :http_prefix, "#{prefix}/"
end
