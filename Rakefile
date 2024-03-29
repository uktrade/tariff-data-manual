require 'rake'
require 'yaml'

CONFIG = YAML.load_file 'config/tech-docs.yml'
GITHUB_REPO = CONFIG['github_repo']
PREFIX = (ENV['GITHUB_REPOSITORY'] || '').partition('/')[-2..-1].join

INPUT_DIR  = 'wiki'
OUTPUT_DIR = 'source/documentation'
IMAGES_DIR = 'source/images'
SEPARATOR  = ';-'

SOURCE_DATABASE = 'https://data.api.trade.gov.uk/v1/datasets/uk-tariff-2021-01-01/versions/latest/data?format=sqlite&download'
LOCAL_DATABASE = ENV['LOCAL_DATABASE'] || 'tariff.sqlite'

# Export for use in docs render
ENV['LOCAL_DATABASE'] = LOCAL_DATABASE

WIKI_FILES   = FileList["#{INPUT_DIR}/*.md"]
OUTPUT_FILES = WIKI_FILES.map do |n|
  File.join *n.gsub(INPUT_DIR, OUTPUT_DIR).
               gsub(/[^a-zA-Z0-9\-\/\;\.]+/, '-').
               gsub('.md','.html.md.erb').
               downcase.split(SEPARATOR)
end
INDEX_FILE   = File.join OUTPUT_DIR, '../', 'index.html.md.erb'

IMAGE_FILES = FileList["#{INPUT_DIR}/images/*.*"]
OUTPUT_IMAGES = IMAGE_FILES.map {|n| File.join IMAGES_DIR, n.pathmap('%f') }

TOP_LEVEL_HEADER = /^#\s+.*$/
FRONT_MATTER = /---\n(.*)\n---\n/m

INFORMATIVE_BLOCK = '''
<% if current_page.data.normative == false %>
  <details>
    <summary>This section is not part of the standard</summary>
    <div class="govuk-details__text">
      <p>The content in this section is only included to help explain the standard,
      provide examples or make recommendations about use.</p>
      <p>It does not contain requirements for complying with the standard
      and is not governed by the formal standards process.</p>
      <p>The information may not have been updated to accurately reflect
      Government policy.</p>
    </div>
  </details>
<% end %>
'''

def patch relative_path, patch_filename
  begin
    full_path = Gem.find_files(relative_path).first
    unless full_path.nil?
      sh 'patch', '--forward', full_path, '-i', patch_filename
      full_path
    end
  rescue
    rake_output_message "Patch #{patch_filename} not applied?"
  end
end

task default: :build

task pages: OUTPUT_FILES

task images: OUTPUT_IMAGES

task :patches do
  patch "assets/javascripts/_modules/collapsible-navigation.js", "gem-patches/collapsible-navigation.js.patch"
  patch "assets/stylesheets/modules/_collapsible.scss", "gem-patches/collapsible.scss.patch"
  full_path = patch("assets/javascripts/_modules/search.js", "gem-patches/search.js.patch")
  unless full_path.nil?
    mv full_path, full_path + ".erb"
  end
end

task build: [:pages, :images, :patches, LOCAL_DATABASE] do
  sh 'middleman', 'build', '--verbose'
  sh 'sed', '-i', "s:url(\"/images/:url(\"#{PREFIX}/images/:", *Dir.glob('build/stylesheets/*.css')
end

OUTPUT_FILES.zip(WIKI_FILES).sort_by(&:first).each_with_index do |(output, input), index|
  directory File.dirname output
  file output => [input, File.dirname(output)] do
    title = output.pathmap('%f').split('.').first.gsub('-',' ').capitalize
    output = (input.pathmap('%n') == 'Home') ? INDEX_FILE : output
    File.open(output, 'w') do |o|
      rake_output_message "echo ... > #{output}"
      contents = File.read input
      header_line = contents.scan(TOP_LEVEL_HEADER).first || "# #{title}"
      front_matter = (contents.scan(FRONT_MATTER).first || [""]).first
      o.puts '---'
      o.puts "title: \"#{title}\""
      o.puts "source_url: \"#{File.join 'https://github.com', GITHUB_REPO, 'wiki', input.pathmap('%n')}\""
      o.puts 'weight: 0' if output == INDEX_FILE
      o.puts "weight: #{index}" if not (front_matter.include?("weight: ") || output == INDEX_FILE)
      o.puts front_matter
      o.puts '---'
      o.puts header_line
      o.puts INFORMATIVE_BLOCK
      o.puts '<%= toc(current_page) %>'
      o.puts contents.gsub(TOP_LEVEL_HEADER, '').gsub(FRONT_MATTER, '')
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

file LOCAL_DATABASE do
  require 'open-uri'
  rake_output_message "curl '#{SOURCE_DATABASE}' > #{LOCAL_DATABASE}"
  IO.copy_stream URI.open(SOURCE_DATABASE), LOCAL_DATABASE
end\

task :serve => [:build] do
  sh 'middleman', 'serve'
end

task :clean do
  rm_rf OUTPUT_DIR
  rm_rf IMAGES_DIR
  rm_rf INDEX_FILE
  rm_rf 'build'
end
