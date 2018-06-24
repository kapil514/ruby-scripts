#!/usr/bin/ruby
file='/home/Kapil/serverlist/Solr_Indexer_list'
f = File.open(file, "r")
f.each_line do |line|
#  puts line
 str = "nodes.transform('name:#{line}'){|n| n.run_list<< role['hosts_file']}"
 `knife exec -E "#{str}"`
end
f.close
