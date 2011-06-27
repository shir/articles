#require File.expand_path('lib/tasks/converting', __FILE__)

require 'redcarpet'
require 'albino'
require 'nokogiri'

MD_EXTENSION = '.md'
ARTICLES_DIRS = %w[rails ruby vim]
HTML_OUTPUT_DIR = 'html'

def output_file(dir, input_file)
  base_file_name = File.basename(input_file, MD_EXTENSION) + '.html'
  File.expand_path(File.join('..', 'html', dir, base_file_name), __FILE__)
end

def syntax_highlighter(html)
  doc = Nokogiri::HTML(html)
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  doc.to_s
end

def convert_file_to_html(file, output_file)
  options = [:autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
  result = syntax_highlighter(Redcarpet.new(IO.read(file), *options).to_html)
  FileUtils.makedirs(File.dirname(output_file))
  File.open(output_file, 'w') { |f| f.write(result) }
end

namespace :convert do
  desc 'Convert all articles to HTML format'
  task :html do
    ARTICLES_DIRS.each do |dir|
      Dir.foreach(File.expand_path(File.join('..', dir), __FILE__)) do |file|
        if File.extname(file) == MD_EXTENSION
          input_file = File.expand_path(File.join('..', dir, file), __FILE__)
          convert_file_to_html(input_file, output_file(dir, input_file))
        end
      end
    end
  end
end
