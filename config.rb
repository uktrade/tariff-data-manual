require 'govuk_tech_docs'

GovukTechDocs.configure(self)

class DiagramRenderer < GovukTechDocs::TechDocsHTMLRenderer
  def initialize(options = {})
    @local_options = options.dup
    @app = @local_options[:context].app
    super
  end

  def block_code code, language
    if language =~ /diagram/
      "<div class=\"mermaid\">#{code}</div>"
    else
      super code, language
    end
  end

  def postprocess args
    # Disable Smartypants
    return args
  end
end

set :markdown,
  renderer: DiagramRenderer.new(
    with_toc_data: true,
    api: true,
    context: self,
    smartypants: false
  ),
  fenced_code_blocks: true,
  tables: true,
  no_intra_emphasis: true,
  smartypants: false

configure :build do
  prefix = (ENV['GITHUB_REPOSITORY'] || '').partition('/')[-2..-1].join
  set :http_prefix, "#{prefix}/"
end