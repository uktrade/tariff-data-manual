module TableOfContents
  # https://gist.github.com/backflip/7446094
  def toc(page)
    html_toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)
    file = ::File.read(page.source_file)

    # remove YAML frontmatter
    file = file.gsub(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m,'')

    # remove top level headings
    file = file.gsub(/^#/,'')

    html_toc.render file
  end
end
