#!/usr/bin/env ruby

require 'dyndoc/document'

## p Dyndoc.cfg_dir


d=Dyndoc::TemplateDocument.new(ARGV[0])

d.make_all