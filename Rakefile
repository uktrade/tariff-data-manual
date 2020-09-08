require 'rake'
require 'yaml'

CONFIG = YAML.load_file 'config/tech-docs.yml'
GITHUB_REPO = CONFIG['github_repo']

INPUT_DIR  = 'wiki'
OUTPUT_DIR = 'source/documentation'
SEPARATOR  = ';-'

WIKI_FILES   = FileList["#{INPUT_DIR}/*"]
OUTPUT_FILES = WIKI_FILES.map {|n| File.join *n.gsub(INPUT_DIR, OUTPUT_DIR).gsub('.md','.html.md.erb').downcase.split(SEPARATOR) }
INDEX_FILE   = File.join OUTPUT_DIR, '../', 'index.html.md.erb'

task default: :build

task build: OUTPUT_FILES do
  sh 'middleman', 'build', '--verbose'
end

OUTPUT_FILES.zip(WIKI_FILES).each do |output, input|
  directory File.dirname output
  file output => [input, File.dirname(output)] do
    title = output.pathmap('%f').split('.').first.gsub('-',' ').capitalize
    output = (input.pathmap('%n') == 'Home') ? INDEX_FILE : output
    File.open(output, 'w') do |o|
      rake_output_message "echo ... > #{output}"
      contents = File.read input
      o.puts '---'
      o.puts "title: \"#{title}\""
      o.puts "source_url: \"#{File.join 'https://github.com', GITHUB_REPO, 'wiki', input.pathmap('%n')}\""
      o.puts 'weight: 0' if output == INDEX_FILE
      o.puts '---'
      o.puts "# #{title}" unless contents =~ /^#\s\S+/
      o.puts contents
    end
  end
end

task :clean do
  rm_rf OUTPUT_DIR
  rm_rf INDEX_FILE
  rm_rf 'build'
end
