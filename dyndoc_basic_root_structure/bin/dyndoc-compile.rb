#!/usr/bin/env ruby
require 'dyndoc/document'

## p Dyndoc.cfg_dir

require 'optparse'

OptionParser.new do |opts|
  opts.banner = "Usage: dyndoc-compile.rb [options]"

  opts.on("-d", "--docs one,two,three", Array, "list of documents to compile") do |list|
    Settings["cfg_dyn.doc_list"] = list
  end

  opts.on("-f", "--format ", "format of the dyndoc document") do |format|
    Settings["cfg_dyn.format_doc"] = format.to_sym
  end

  opts.on('-t','--tags TAGS',Array,'filter tags') {|t| Settings["cfg_dyn.tag_tmpl"] = t}

  opts.on('-C',"--content-only", "content only mode (no header!)") do
    Settings["cfg_dyn.model_doc"] = "Content"
  end

  opts.on('-c', '--cmd COMMAND','[a(rchive old)][r(emove old)][s(ave)][pdf(latex)]') {|c|
    cmd =[:make_content]
    cmd << :save_old if c.include? "a"
    cmd << :rm_old if c.include? "r"
    cmd << :save if c.include? "s"
    ## cmd << :cat if c.include? "c"
    cmd << :pdf  if c =~ /(E)?pdf([1-3])?/ #if c.include? "pdf"
    Settings["cfg_dyn.options.pdflatex_echo"]=true if $1 # useable for log sytem (to introduce possibly later)
    Settings["cfg_dyn.options.pdflatex_nb_pass"]=$2.to_i if $2
    ## cmd << :png if c.include? "png"
    ## cmd << :view if c.include? "v"
    ## cmd << :save << :view if c.include? "x"
    ## cmd =[:cat] if cmd.empty? #and  cfg_dyn[:model_doc]=="content"
    ## cmd = [:pdf] if c=="pdf" #only pdflatex
    Settings["cfg_dyn.cmd_doc"] = cmd 
  }

  opts.on("-l", "--list", "list of documents available") do
    Settings["cfg_dyn.cmd_doc"] = [:list]
  end

  opts.on("-p", "--pandoc ", "filter for pandoc (tex2docx,...)") do |f|
    #p [:pandoc,f]
    Settings["cfg_dyn.pandoc_filter"] = f
  end

  # opts.on('--docker',"docker mode") do
  #     Settings["cfg_dyn.docker_mode"]=true
  # end

end.parse!

## ARGV is consumed before
doc=ARGV[0]

d=Dyndoc::TemplateDocument.new(doc)

d.make_all