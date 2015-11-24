#!/usr/bin/ruby

require 'faye/websocket'
require 'permessage_deflate'
require 'rack'
require "dyndoc-core"
require File.dirname(__FILE__)+"/session_manager"

static  = Rack::File.new(File.join(File.dirname(__FILE__),"session"))
options = {:extensions => [PermessageDeflate], :ping => 5}

Dyndoc.cfg_dyn['dyndoc_session']=:interactive
tmpl_mngr = Dyndoc::Ruby::TemplateManager.new({})
##is it really well-suited for interactive mode???
tmpl_mngr.init_doc({:format_output=> "html"})
puts "InteractiveServer initialized!\n"
tmpl_mngr.as_default_tmpl_mngr! #=> Dyndoc.tmpl_mngr activated!

sessionMngr = SessionMngr.new

DyndocServerApp = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env, ['irc', 'xmpp'], options)
    p [:open, ws.url, ws.version, ws.protocol]

    ws.onmessage = lambda do |event|
      data=event.data
      #p [:data,event.data]
      if data =~ /^__send_cmd__\[\[([a-z,_]*)(\#[^\]]*)?\]\]__(.*)__\[\[WS_END_TOKEN\]\]__$/m
        cmd,id,content = $1,$2,$3
        ##p [:cmd,cmd,:content,content]
        case cmd
        when "dyndoc"
          # res = process_dyndoc(content)
          content=tmpl_mngr.parse(content)
          tmpl_mngr.filterGlobal.envir["body.content"]=content #+"2"
          ##p [:dyndoc_server,content,res]
          #p [:sent,"__send_cmd__[[dyndoc"+(id||"")+"]]__"+content+"__[[WS_END_TOKEN]]__"]
          ws.send "__send_cmd__[[dyndoc"+(id||"")+"]]__"+content+"__[[WS_END_TOKEN]]__"
        when "session_login"
          if id and sessionMngr.is_session? id
            if content =~ /^([^\|]*)\|([^\|]*)\|([^\|]*)$/
              user,passwd,info=$1,$2,$3
              sessionMngr.session_user_add(id,ws,user,info) if sessionMngr.session_ok?(id,passwd)
            else

            end
            p [id,sessionMngr.session_show(id)]
          end
        ## All actions above are admin tasks
        when "session_new"
          # content is here the password supplied by for other clients
          sessionMngr.session_new(id,content) unless sessionMngr.is_session?(id)
          p sessionMngr.session_ls
          ws.send "__send_cmd__[[dyndoc#session_list]]__"+sessionMngr.sessions_summary+"__[[WS_END_TOKEN]]__"
        when "session_remove"
          sessionMngr.session_remove(id)
          p sessionMngr.session_ls
          ws.send "__send_cmd__[[dyndoc#session_list]]__"+sessionMngr.sessions_summary+"__[[WS_END_TOKEN]]__"
        when "session_ls"
          ws.send "__send_cmd__[[dyndoc#session_list]]__"+sessionMngr.sessions_summary+"__[[WS_END_TOKEN]]__"
        when "session_all_clients_element"
          cmd,jq_id=content.strip.split(",").map{|e| e.strip}
          cmd_for_client="__send_cmd__[[jquery_"+cmd+"#"+jq_id+"]]____[[WS_END_TOKEN]]__"
          p [:cmd_for_client,cmd_for_client]
          sessionMngr.session_all_ws_clients(id).each do |ws_cli|
            ws_cli.send cmd_for_client
          end
        end
      end
      
    end

    ws.onclose = lambda do |event|
      p [:close, event.code, event.reason]
      p [:ws,ws.object_id]
      sessionMngr.session_user_remove(ws)
      ws = nil
    end

    ws.rack_response

  else
    static.call(env)
  end
end

def DyndocServerApp.log(message)
end