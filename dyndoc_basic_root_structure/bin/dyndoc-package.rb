#!/usr/bin/env ruby

require 'fileutils'
require 'dyndoc/init/home'
dyndoc_home = Dyndoc.home
#p Dyndoc.home

lib_dir = File.join(dyndoc_home,"library")
repo_dir = File.join(dyndoc_home,"library",".repository")

old_pwd = Dir.pwd

cmd = ARGV[0].to_sym
case cmd

# dyndoc-package install rcqls/dyndoc-share
when :install  #default is github from now!
owner,package=File.split(ARGV[1])
package = package[0...-4] if package =~ /\.git$/
package_dir = File.join(repo_dir,owner)
FileUtils.mkdir_p package_dir
FileUtils.cd package_dir
`git clone https://github.com/#{owner}/#{package}.git`

# dyndoc-package update rcqls/dyndoc-share
when :update
FileUtils.cd File.join(repo_dir,ARGV[1])
`git pull`

# dyndoc-package link rcqls/dyndoc-share/library/RCqls (default to RCqls)
# dyndoc-package link rcqls/dyndoc-share/library/RCqls rcqls
when :link
path,package = File.split(ARGV[1])
target = ARGV[2] || package
FileUtils.ln_sf File.join(repo_dir,path,package),File.join(lib_dir,target)

# dyndoc-package unlink RCqls
when :unlink
package = ARGV[1]
FileUtils.rm File.join(lib_dir,package)

when :ls
FileUtils.cd lib_dir
Dir["*"].each_with_index{|e,i| puts "#{i+1}) #{e}"}

when :repo
FileUtils.cd repo_dir
Dir[File.join("*","*")].each_with_index{|e,i| puts "#{i+1}) #{e}"}

end

FileUtils.cd old_pwd