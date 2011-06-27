require 'redcarpet'
require 'albino'
require 'nokogiri'

ROOT_DIR = File.expand_path(File.join('..', '..', '..'), __FILE__)
MD_DIR = File.join(ROOT_DIR, 'markdown')
HTML_DIR = File.join(ROOT_DIR, 'html')
MD_EXTENSION = '.md'

def output_file(input_file)
  puts Regexp.escape(MD_DIR)
  puts Regexp.escape(HTML_DIR)
  input_file.gsub(/^#{Regexp.escape(MD_DIR)}/, Regexp.escape(HTML_DIR)).
    gsub(/#{Regexp.escape(MD_EXTENSION)}$/, '.html')
end

def syntax_highlighter(html)
  doc = Nokogiri::HTML(html)
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  doc.to_s
end

def convert_file_to_html(input_file, output_file)
  puts "Processing #{input_file} to #{output_file}"
  options = [:autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
  result = syntax_highlighter(Redcarpet.new(IO.read(input_file), *options).to_html)
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
end