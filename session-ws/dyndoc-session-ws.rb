#!/usr/bin/ruby

require 'faye/websocket'
require 'permessage_deflate'
require 'rack'
require "dyndoc-core"
require File.dirname(__FILE__)+"/session_manager"
require File.dirname(__FILE__)+"/answers_manager"

static  = Rack::File.new(static_root=File.join(File.dirname(__FILE__),"session"))
options = {:extensions => [PermessageDeflate], :ping => 5}

Dyndoc.cfg_dyn['dyndoc_session']=:interactive
tmpl_mngr = Dyndoc::Ruby::TemplateManager.new({})
##is it really well-suited for interactive mode???
tmpl_mngr.init_doc({:format_output=> "html"})
puts "InteractiveServer initialized!\n"
tmpl_mngr.as_default_tmpl_mngr! #=> Dyndoc.tmpl_mngr activated!

def send_dyndoc(ws,id,content="")
  ws.send "__send_cmd__[[dyndoc"+(id||"")+"]]__"+content+"__[[WS_END_TOKEN]]__"
end

def send_jquery(ws,cmd,id,content="")
  ws.send "__send_cmd__[[jquery_"+cmd+id+"]]__"+content+"__[[WS_END_TOKEN]]__"
end

ws_admin=nil

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
          send_dyndoc(ws,id,content)
        when "session_login"
          if id and Session.mngr.is_session? id
            if content =~ /^([^\|]*)\|([^\|]*)\|([^\|]*)$/
              user,passwd,info=$1,$2,$3
              msg=""
              if Session.mngr.session_ok?(id,passwd)
                Session.mngr.session_user_add(id,ws,user,info)
                msg="User #{user} connected and ready to play!"
              else
                msg = "User #{user} disconnected! Bad session id or password!"
              end
              #p msg
              send_dyndoc(ws,"#session_msg",msg)
              send_dyndoc(ws_admin,"#session_list",Session.mngr.sessions_summary)
            else
              p "ici"
            end
            p [id,Session.mngr.session_show(id)]
          end
        when "session_answer"
          if id and Session.mngr.is_session? id

            if (user=Session.mngr.session_user_id(id,ws))

              if content =~ /^([^\|]*)\|([^\|]*)$/
                qid,answer=$1,$2
                Answers.mngr.set_user_answer(id,user,qid,answer)
                msg="Answer sent!"
              else
                msg="Answer not sent!"
              end
            else
              # Normally this does never happen!
              msg="User not registered for this session!"
            end
            p [:msg,msg]
            send_dyndoc(ws,"#session_msg",msg)
          end

        ## All actions above are admin tasks
      when "session_admin_login"
          #content is here the admin password
          p [:passwd_admin,content]
          if Session.mngr.session_admin_login? content
            send_jquery(ws,"hide","#session_admin_login")
            send_jquery(ws,"hide","#session_msg")
            send_jquery(ws,"show","#session_admin")
            #p Answers.mngr.load_form_list
            send_jquery(ws,"html","#session_id_admin",Answers.mngr.load_form_list)
            send_jquery(ws,"trigger","#session_id_admin","change")
            send_dyndoc(ws,"#session_list",Session.mngr.sessions_summary)
            # register ws_admin
            ws_admin = ws
          else
            send_jquery(ws,"html","#session_msg","Bad password!")
          end
        when "session_admin_question_view"
          ##p [:id,id,:content,content]
          html_content=Session.mngr.session_question(id,content,[:html])
          ##p [:session_admin_question_view,html_content]
          send_jquery(ws_admin,"html","#session_question_view",html_content)
        when "session_new"
          if Session.mngr.session_admin_ok?
            # content is here the password supplied by for other clients
            Session.mngr.session_new(id,content) unless Session.mngr.is_session?(id)
            p Session.mngr.session_ls
            send_dyndoc(ws,"#session_list",Session.mngr.sessions_summary)
            send_jquery(ws,"html","#session_question_id_admin",Answers.mngr.load_question_list(id))
            send_jquery(ws,"trigger","#session_question_id_admin","change")
          end
        when "session_reload"
          p [:session_reload,Session.mngr.session_admin_ok?]
          if Session.mngr.session_admin_ok?
            Session.mngr.session_reload_questions(id)
            send_jquery(ws,"html","#session_question_id_admin",Answers.mngr.load_question_list(id))
          end
        when "session_remove"
          if Session.mngr.session_admin_ok?
            Session.mngr.session_remove(id)
            p Session.mngr.session_ls
            send_dyndoc(ws,"#session_list",Session.mngr.sessions_summary)
          end
        when "session_ls"
          if Session.mngr.session_admin_ok?
            p [:session_id,id]
            send_dyndoc(ws,"#session_list",Session.mngr.sessions_summary)
          end
        when "session_all_clients_element"
          cmd,qid=content.strip.split(",").map{|e| e.strip}
          html_content=""
          case cmd
          when "show"
            html_content=Session.mngr.session_question(id,qid) || ""
          when "hide"

          end

          Session.mngr.session_all_ws_clients(id).each do |ws_cli|
            send_jquery(ws_cli,"html","#session_content",html_content)
          end
        end
      end

    end

    ws.onclose = lambda do |event|
      p [:close, event.code, event.reason]
      p [:ws,ws.object_id]
      Session.mngr.session_user_remove(ws)
      ws = nil
    end

    ws.rack_response

  else
    ##p [:env,env]
    path_info=File.join(File.dirname(env["PATH_INFO"]),File.basename(env["PATH_INFO"],".html"))
    local=(env["REMOTE_ADDR"]=="127.0.0.1" ? "_local" : "")
    if path_info == "/admin"
      env["PATH_INFO"]="/mobile/admin/session_admin"+local+".html"
    elsif path_info == "/register"
      env["PATH_INFO"]="/mobile/admin/session_register"+local+".html"
    else
      file_ext=(!(path_info.include? ".")) ? ".html" : ""
      ##p [:html_files_dir,File.join(static_root,"questions","**"+path_info+local+file_ext)]
      html_files=Dir[File.join(static_root,"questions","**"+path_info+local+file_ext)]
      ##p [:html_files,html_files]
      unless html_files.empty?
        html_file="/"+Pathname(html_files[0]).relative_path_from(Pathname(static_root)).to_s
        ##p [:html_file,html_file,html_files]
        env["PATH_INFO"]=html_file
      end
    end
    static.call(env)
  end
end

def DyndocServerApp.log(message)
end
