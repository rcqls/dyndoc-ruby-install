#!/usr/bin/env ruby

require "socket"

module Dyndoc
	class Client
		
		attr_reader :content

		@@end_token="__[[END_TOKEN]]__"

		def initialize(cmd,addr="127.0.0.1",port=7777)
			@addr,@port,@cmd=addr,port,cmd

			Socket.tcp(addr, 7777) {|sock|
  				sock.print '__send_cmd__[[dyndoc]]__' + @cmd + @@end_token
  				sock.close_write
  				@result=sock.read
			}

			data=@result.split(@@end_token,-1)
			last=data.pop
			resCmd=decode_cmd(data.join(""))
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

arg=ARGV[0]

dyn_output=ARGV[1]

if arg.include? "@"
	arg,addr=arg.split("@")
else
	addr="127.0.0.1"
end

dyn_file,dyn_layout=nil,nil

if arg.include? ","
	dyn_file,dyn_layout=arg.split(",")
else
	dyn_file=arg
	if i=(dyn_file =~ /\_?(?:html|tex)?\.dyn$/)
		dyn_layout=dyn_file[0...i]+"_layout.dyn" if File.exist? dyn_file[0...i]+"_layout.dyn"		
	end
end

dyn_file=nil unless File.exist? dyn_file
dyn_layout=nil if dyn_layout and !File.exist? dyn_layout

if dyn_file
	code=File.read(dyn_file)
	cli=Dyndoc::Client.new(code,addr)

	if dyn_layout
	 	cli=Dyndoc::Client.new(File.read(dyn_layout),addr)
	end

	if dyn_output and Dir.exist? File.dirname(dyn_output)
		File.open(dyn_output,"w") do |f|
			f << cli.content
		end
	else
		puts cli.content
	end
end 