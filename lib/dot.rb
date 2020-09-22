DOT_ARGS = [
  '-Tsvg',
  '-Nfontname=Arial'
]

def dot_to_svg code
  svg = IO.popen(['dot', *DOT_ARGS], mode: 'r+') do |dot|
    dot.write code
    dot.close_write
    dot.read
  end
  /<svg.*<\/svg>/m.match(svg)[0]
end
