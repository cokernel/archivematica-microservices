require 'yaml'
require 'rubygems'
require 'json'

url = ARGV[0]
erc_file = ARGV[1]
identifier = ARGV[2]

yaml = YAML.load_file(erc_file)

metadata = {
  :id => identifier,
  :title_display => yaml['what'],
  :mets_url_s => url,
  :who_s => yaml['who'],
  :what_s => yaml['what'],
  :where_s => yaml['where'],
  :when_s => yaml['when']
}

puts metadata.to_json
