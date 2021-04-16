require 'rake'
require 'yaml'

CONFIG = YAML.load_file 'config/tech-docs.yml'
GITHUB_REPO = CONFIG['github_repo']
PREFIX = (ENV['GITHUB_REPOSITORY'] || '').partition('/')[-2..-1].join

INPUT_DIR  = 'wiki'
OUTPUT_DIR = 'source/documentation'
IMAGES_DIR = 'source/images'
SEPARATOR  = ';-'

WIKI_FILES   = FileList["#{INPUT_DIR}/*.md"]
OUTPUT_FILES = WIKI_FILES.map {|n| File.join *n.gsub(INPUT_DIR, OUTPUT_DIR).gsub('.md','.html.md.erb').downcase.split(SEPARATOR) }
INDEX_FILE   = File.join OUTPUT_DIR, '../', 'index.html.md.erb'

IMAGE_FILES = FileList["#{INPUT_DIR}/images/*.*"]
OUTPUT_IMAGES = IMAGE_FILES.map {|n| File.join IMAGES_DIR, n.pathmap('%f') }

TOP_LEVEL_HEADER = /^#\s+.*$/

def patch relative_path, patch_filename
  full_path = Gem.find_files(relative_path).first
  unless full_path.nil?
    sh 'patch', full_path, '-i', patch_filename
    full_path
  end
end

task default: :build

task pages: OUTPUT_FILES

task images: OUTPUT_IMAGES

task :patches do
  full_path = patch("assets/javascripts/_modules/search.js", "gem-patches/search.js.patch")
  unless full_path.nil?
    mv full_path, full_path + ".erb"
  end
end

task build: [:pages, :images, :patches] do
  sh 'middleman', 'build', '--verbose'
  sh 'sed', '-i', "s:url(\"/images/:url(\"#{PREFIX}/images/:", *Dir.glob('build/stylesheets/*.css')
end

OUTPUT_FILES.zip(WIKI_FILES).each do |output, input|
  directory File.dirname output
  file output => [input, File.dirname(output)] do
    title = output.pathmap('%f').split('.').first.gsub('-',' ').capitalize
    output = (input.pathmap('%n') == 'Home') ? INDEX_FILE : output
    File.open(output, 'w') do |o|
      rake_output_message "echo ... > #{output}"
      contents = File.read input
      header_line = contents.scan(TOP_LEVEL_HEADER).first || "# #{title}"
      o.puts '---'
      o.puts "title: \"#{title}\""
      o.puts "source_url: \"#{File.join 'https://github.com', GITHUB_REPO, 'wiki', input.pathmap('%n')}\""
      o.puts 'weight: 0' if output == INDEX_FILE
      o.puts '---'
      o.puts header_line
      o.puts '<%= toc(current_page) %>'
      o.puts contents.gsub(TOP_LEVEL_HEADER, '')
      o.puts '<%= stylesheet_link_tag :dot %>' if contents =~ /^```dot/ || contents =~ /^```dbml/
    end
  end
end

OUTPUT_IMAGES.zip(IMAGE_FILES).each do |output, input|
  directory File.dirname(output)
  file output => [input, File.dirname(output)] do
    cp input, output
  end
end

task :clean do
  rm_rf OUTPUT_DIR
  rm_rf IMAGES_DIR
  rm_rf INDEX_FILE
  rm_rf 'build'
end
