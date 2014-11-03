#!/usr/bin/env ruby
require 'dyndoc/document'

## p Dyndoc.cfg_dir

require 'optparse'

OptionParser.new do |opts|
  opts.banner = "Usage: dyndoc-compile.rb [options]"

  opts.on("-d", "--docs one,two,three", Array, "list of documents to compile") do |list|
    Settings["cfg_dyn.doc_list"] = list
  end

  opts.on('-c', '--cmd COMMAND','[s(ave)][b(ackup)][c(at)][pdf|png][v(iew)] and x=sv') {|c|
    cmd =[]
    cmd << :save if c.include? "s"
    cmd << :backup if c.include? "b"
    cmd << :cat if c.include? "c"
    cmd << :pdf if c.include? "pdf"
    cmd << :png if c.include? "png"
    cmd << :view if c.include? "v"
    cmd << :save << :view if c.include? "x"
    cmd =[:cat] if cmd.empty? #and  cfg_dyn[:model_doc]=="content"
    Settings["cfg_dyn.cmd_doc"] = cmd 
  }

  opts.on("-l", "--list", "list of documents available") do
    Settings["cfg_dyn.cmd_doc"] = [:list]
  end

end.parse!

## ARGV is consumed before
doc=ARGV[0]

d=Dyndoc::TemplateDocument.new(doc)

d.make_all