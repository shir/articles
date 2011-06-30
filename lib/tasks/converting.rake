require 'redcarpet'
require 'albino'
require 'nokogiri'

ROOT_DIR = File.expand_path(File.join('..', '..', '..'), __FILE__)
MD_DIR = File.join(ROOT_DIR, 'markdown')
HTML_DIR = File.join(ROOT_DIR, 'html')
MD_EXTENSION = '.md'
HTML_EXTENSION = '.html'
STYLE_FILE = File.join(ROOT_DIR, 'styles', 'colorful.css')

def output_file(input_file)
  input_file.gsub(/^#{Regexp.escape(MD_DIR)}/, Regexp.escape(HTML_DIR)).
    gsub(/#{Regexp.escape(MD_EXTENSION)}$/, HTML_EXTENSION)
end

def style
  @style ||= IO.read(STYLE_FILE)
end

def syntax_highlighter(html)
  doc = Nokogiri::HTML(html)
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  if ENV['INCLUDE_CSS']
    doc.search("//body").first.children.first.before("<style type=\"text/css\">#{style}</style>")
  end
  doc.to_html(:encoding => 'utf-8')
end

def convert_file_to_html(input_file, output_file)
  options = [:autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
  result = Redcarpet.new(IO.read(input_file), *options).to_html
  unless ENV['NO_HIGHLIGHT']
    result = syntax_highlighter(result)
  end
  FileUtils.makedirs(File.dirname(output_file))
  File.open(output_file, 'w') { |f| f.write(result) }
end

namespace :convert do
  desc 'Convert all articles to HTML format'
  task :html do
    Dir.glob(File.join(MD_DIR, '**', "*#{MD_EXTENSION}")).each do |file|
      convert_file_to_html(file, output_file(file))
    end
  end

  desc 'Remove all HTML output files'
  task [:html, :clear] do
    FileUtils.remove_dir(HTML_DIR)
  end
end
