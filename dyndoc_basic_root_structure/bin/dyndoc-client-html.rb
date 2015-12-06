#!/usr/bin/env ruby

require "socket"

module Dyndoc

	class Client
		
		attr_reader :content

		@@end_token="__[[END_TOKEN]]__"

		## reinit is an array 
		def initialize(cmd,tmpl_filename,addr="127.0.0.1",reinit=[],port=7777)
			
			@addr,@port,@cmd,@tmpl_filename=addr,port,cmd,tmpl_filename
			##p [:tmpl_filename,@tmpl_filename]
			## The layout needs to be reintailized for new dyndoc file but not for the layout (of course)!
			dyndoc_cmd="dyndoc" 
			dyndoc_cmd += "_with_tag_tmpl" if reinit.include? :dyndoc_tag_tmpl
			dyndoc_cmd += "_with_libs_reinit" if reinit.include? :dyndoc_libs
			dyndoc_cmd += "_with_layout_reinit" if reinit.include? :dyndoc_layout

			Socket.tcp(addr, 7777) {|sock|
  				sock.print '__send_cmd__[['+dyndoc_cmd+'|'+@tmpl_filename+']]__' + @cmd + @@end_token
  				sock.close_write
  				@result=sock.read
			}

			data=@result.split(@@end_token,-1)
			last=data.pop
			resCmd=decode_cmd(data.join(""))
			##p [:resCmd,resCmd]
			if resCmd[:cmd] != "windows_platform"
				@content=resCmd[:content]
			end
		end

		def decode_cmd(res)
		  if res =~ /^__send_cmd__\[\[([a-zA-Z0-9_]*)\]\]__([\s\S]*)/m
		  	return {cmd: $1, content: $2}
		  end
		end

		# def listen
		# 	##@response = Thread.new do
		# 	result=""
		# 	@content=nil
		# 	msg=""
		# 	loop {
		# 		msg=@server.recv(1024)
		# 		##p msg
		# 		if msg
		# 			msg.chomp! 
		# 			##puts "#{msg}"
		# 			data=msg.split(@@end_token,-1)
		# 			##p data
		# 			last=data.pop
		# 			result += data.join("") 
		# 			#p "last:<<"+last+">>"
		# 			if last == ""
		# 				#console.log("<<"+result+">>")
		# 				resCmd = decode_cmd(result)
		# 				##p resCmd
		# 				if resCmd[:cmd] != "windows_platform"
		# 					#console.log("data: "+resCmd["content"])
		# 					@content=resCmd[:content]
		# 					@server.close
		# 					break
		# 				end
		# 			else
		# 				result += last if last
		# 			end
		# 		end
		# 	}
		# 	#end
		# end
	end
end


# USAGE:
# dyndoc-ruby-client.rb test.dyn[@127.0.0.1] [output_filename.html]
# dyndoc-ruby-client.rb test.dyn,layout.dyn[@127.0.0.1] [output_filename.html]

next_i=0
dyn_tag_tmpl=nil

## very limited tags system
if ARGV[0] =~ /\-t\=/
	next_i=1
	dyn_tag_tmpl="[#<]{#opt]"+ARGV[0][3..-1].strip+"[#opt}"
end

arg=ARGV[next_i]
dyn_output=ARGV[next_i + 1]



if arg.include? "@"
	arg,addr=arg.split("@")
else
	addr="127.0.0.1"
end

dyn_file,dyn_layout,dyn_libs=nil,nil,nil

if arg.include? ","
	dyn_file,dyn_layout=arg.split(",")
else
	dyn_file=arg
	if i=(dyn_file =~ /\_?(?:html|tex)?\.dyn$/)
		dyn_layout=dyn_file[0...i]+"_layout.dyn" if File.exist? dyn_file[0...i]+"_layout.dyn"		
	end
end

if !dyn_layout and File.exist? ".dyn_layout"
	dyn_layout=File.read(".dyn_layout").strip
end

if !dyn_layout and File.exist?(etc_dyn_layout=File.join(ENV["HOME"],".dyndocker","etc","dyn_cli_layout"))
	dyn_layout=File.read(etc_dyn_layout).strip
end

if !dyn_libs and File.exist? ".dynlibs" 
	dyn_libs='[#require]\n'+File.read(etc_dyn_libs).strip+'[#main][#>]'
end

if !dyn_libs and File.exist?(etc_dyn_libs=File.join(ENV["HOME"],".dyndocker","etc","dyn_cli_libs"))
	dyn_libs='[#require]\n'+File.read(etc_dyn_libs).strip+'[#main][#>]'
end

dyn_file=nil unless File.exist? dyn_file
dyn_layout=nil if dyn_layout and !File.exist? dyn_layout

if dyn_file
	code=File.read(dyn_file)
	code = dyn_tag_tmpl+code if dyn_tag_tmpl
	code = '[#require]\n'+dyn_libs+'[#main][#>]' + code if dyn_libs
	dyndoc_start=[:dyndoc_libs,:dyndoc_layout]
	## tag tmpl attempt to communicate to the server
	if dyn_tag_tmpl
		
	end
	cli=Dyndoc::Client.new(code,File.expand_path(dyn_file),addr,dyndoc_start)

	if dyn_layout
	 	cli=Dyndoc::Client.new(File.read(dyn_layout),"",addr) #File.expand_path(dyn_layout),addr)
	end

	if dyn_output and Dir.exist? File.dirname(dyn_output)
		File.open(dyn_output,"w") do |f|
			f << cli.content
		end
	else
		puts cli.content
	end
end 