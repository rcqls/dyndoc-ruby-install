#!/usr/bin/ruby

require 'socket'                # Get sockets from stdlib
require "dyndoc-core"


module Dyndoc

  class InteractiveServer

    def initialize
      @tmpl_mngr=nil
      @tmpl_filename=nil
      init_dyndoc
      init_server
    end

    def init_dyndoc
      unless @tmpl_mngr
        Dyndoc.cfg_dyn['dyndoc_session']=:interactive
        @tmpl_mngr = Dyndoc::Ruby::TemplateManager.new({})
        ##is it really well-suited for interactive mode???
        @tmpl_mngr.init_doc({:format_output=> "html"})
        @tmpl_mngr.require_dyndoc_libs("DyndocWebTools")
        puts "InteractiveServer initialized!\n"
        @tmpl_mngr.as_default_tmpl_mngr! #=> Dyndoc.tmpl_mngr activated!
      end
    end

    def process_dyndoc(content)
      ##p [:process_dyndoc_content,content]
      @content=@tmpl_mngr.parse(content)
      @tmpl_mngr.filterGlobal.envir["body.content"]=@content
      if @tmpl_filename
        @tmpl_mngr.filterGlobal.envir["_FILENAME_CURRENT_"]=@tmpl_filename.dup
        @tmpl_mngr.filterGlobal.envir["_FILENAME_"]=@tmpl_filename.dup #register name of template!!!
        @tmpl_mngr.filterGlobal.envir["_FILENAME_ORIG_"]=@tmpl_filename.dup #register name of template!!!
        @tmpl_mngr.filterGlobal.envir["_PWD_"]=File.dirname(@tmpl_filename)
      end
      return @content
    end

    def init_dyndoc_libs

    end

    def init_server  
      @server = TCPServer.new('0.0.0.0',7777)
    end

    def run
    	trap("SIGINT") { @server.close;exit! }
  		loop {
  			socket = @server.accept

  			b=socket.recv(100000)
  			##p [:b,b]
  			data=b.to_s.strip
  			##p [:data,data]
  			if data =~ /^__send_cmd__\[\[([a-z]*)\|?([^\]]*)?\]\]__(.*)__\[\[END_TOKEN\]\]__$/m
          cmd,@tmpl_filename,content = $1,$2,$3
    			##p [:cmd,cmd,:content,content,:filename,@tmpl_filename]
    			if content.strip == "__EXIT__" 
    				socket.close
    				@server.close
    				break
    			end
    			if cmd == "dyndoc"
    			  res = process_dyndoc(content)
    			  ##p [:dyndoc_server,content,res]
    			  socket.write "__send_cmd__[[dyndoc]]__"+res+"__[[END_TOKEN]]__"
    			elsif cmd == "dyndoc_layout_reinit"
            LayoutMngr.reinit
          end
  			end
  			socket.close
  		}
    end

  end

end

Dyndoc::InteractiveServer.new.run