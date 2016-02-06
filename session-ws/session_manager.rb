class Session

	include MongoidUtils

	@@mngr=nil
	def Session.mngr
		@@mngr=self.new unless @@mngr
		@@mngr
	end

	def initialize
		@sessions = {}
		@ws_clients = {}
		@session_user_ok = {}
		@session_users={}
	end

	def session_admin_login?(try,secret="ThanksLife!")
		@session_admin_ok=false
		#if Module.constants.include? :Mongoid and Module.constants.include? :SessionAdmin
		if mongoid? :SessionAdmin
			secret=SessionAdmin.pluck(:passwd).first
		elsif File.exist?(secret_file=File.join(File.dirname(__FILE__),".secret"))
			secret=File.read(secret_file)
		end
		##p [:secret,secret.strip,try.strip]
		@session_admin_ok= (secret.strip == try.strip)
	end

	# to uncomment for quickly enter password
	def session_admin_login?(try,secret="ThanksLife!")
		@session_admin_ok=true
	end

	def session_admin_ok?
		@session_admin_ok
	end

	def session_new(id,passwd)
		creation_time=Time.now.strftime "%y-%m-%d"
		if (questions=Answers.mngr.load_questions(id,passwd,creation_time))
			@sessions[id] = {:users=>[],:user_info => {},:ws_clients => {},:passwd => passwd,:q_ids => questions[:ids],:questions => questions[:questions],:creation_time => creation_time}
			##p [:sessions,@sessions]
			if mongoid? :QuestionForm
				# form_passwd is passwd completed with day
				crit=QuestionForm.where(form_id: id,form_passwd: creation_time+"_"+passwd)
				if crit.exists?
					@current_question_form_mongo=crit.last
				else
					@current_question_form_mongo=QuestionForm.new({form_id: id, form_passwd: creation_time+"_"+passwd})
					@current_question_form_mongo.save
					# answer affected to user god
					answer={}
					questions[:questions].keys.each{|e| answer[e]=questions[:questions][e][:answer]}
					p [:answer,answer]
					@current_question_form_mongo.user_answers.create({login: "god",question_answers: answer})
				end
				p [:session_new,@current_question_form_mongo]
			end
		else
			puts "No questions for session id #{id}!"
		end
	end

	def question_form?
		@current_question_form_mongo
	end

	def session_creation_time(id)
		@sessions[id][:creation_time]
	end


	## Admin
	def session_reload_questions(id)
		questions=Answers.mngr.reload_questions(id)
		##
		p [:questions,questions,@sessions]
		if (questions and @sessions[id])
			@sessions[id][:q_ids] = questions[:ids]
			@sessions[id][:questions] = questions[:questions]
		end
	end

	def session_answer_id(id)
		@sessions[id][:passwd]
	end

	def session_question(id,qid,mode=[:html,:js])
		res=""
		if @sessions[id]
			questions=@sessions[id][:questions]
			##p [qid,questions.keys]

			mode.each{|m| res << questions[qid][m]} if questions[qid]
		end
		res
	end

	def session_questions(id)
		res=""
		if @sessions[id]
			res << '<div data-role="controlgroup" id="session_question_cg">'
			questions=@sessions[id][:questions]
			questions.keys.each do |qid|
				res << '<div data-role="collapsible" data-collapsed-icon="carat-d" data-expanded-icon="carat-u">' << "\n"
				res << '<h3>'+qid+'<span class="ui-li-count">0</span></h3><span><a class="ui-btn ui-btn-inline ui-icon-refresh ui-btn-icon-notext">'+id[1..-1]+','+qid+'</a></span>' << "\n"
				res << questions[qid][:html]
				# Mathjax is in html: res << questions[qid][:js]
				res << '</div>' << "\n"
			end
			res << '</div>' << "\n"
			res << '<script>' << "\n"
			res << '$(".ui-icon-refresh" ).click(function(ui) {var tmp=ui.currentTarget.innerText.split(",");var id=tmp[0],qid=tmp[1];console.log("ici:"+id+","+qid);send_cmd("session_all_clients_element",id,"show,"+qid);})' << "\n"
			res << '$("#session_question_cg" ).controlgroup().trigger("create");' << "\n"
			res << '</script>'
		end
	end

	def session_remove(id)
		if @sessions.keys.include? id
			@sessions.delete id
		end
	end

	def session_ok?(id,passwd)
		##p [:session_ok,id,passwd,@sessions]
		@sessions[id] and (@sessions[id][:passwd] == passwd)
	end

	def session_ls
		@sessions.keys
	end

	def sessions_summary
		res=[]
		@sessions.keys.map{|id|
			res << id + "(" + session_show(id).join(",") + ")"
		}
		res.empty? ? "" : '<ul><li>'+res.join("</li><li>")+'</li></ul>'
	end

	def sessions_list(html: true,admin: false)
  	form_list=@sessions.keys
		if html
			form_list.map! do |id|
				"<option value='"+(id.strip)[1..-1]+"'>"+id[1..-1]+(admin ? " ("+@sessions[id][:passwd]+")" : "" )+"</option>"
			end
			form_list=form_list.join("\n")
		end
		form_list
	end

	def is_session?(id)
		##p [:session_ls,session_ls,id]
		session_ls.include? id
	end

	def session_show(id)
		@sessions[id][:users]
	end

	def session_user_register(user)
		msg=nil
		user=user.map &:strip
		##if Module.constants.include? :Mongoid and Module.constants.include? :SessionUser
		if mongoid? :SessionUser
			if SessionUser.pluck(:login).to_a.include? user[0]
				msg=[1,"Login already used!"]
			elsif user[4] != user[9]
				msg=[2,"Password not entered twice!"]
			elsif (SessionUser.pluck(:email).to_a.map &:strip).include? user[3]
				msg=[3,"Email account already in use!"]
			else
				SessionUser.create({
					login: user[0], first_name: user[1], last_name: user[2],
					email: user[3], passwd: user[4],
					year: user[5], section: user[6], group: user[7],
					comment: user[8]
				})
				msg=[0,"Account for user "+user[0]+" just created! You can quit this page!"]
			end
		end
		return msg
	end

	def session_user_login?(login,passwd,ws_client)
		@session_user_ok[ws_client]=false
		##if Module.constants.include? :Mongoid and Module.constants.include? :SessionUser
		if mongoid? :SessionUser
			secret=SessionUser.where(login: login).pluck(:passwd).first
			##p [:secret,secret.strip,try.strip]
			@session_user_ok[ws_client]= (secret == passwd)
			@session_users[ws_client]={login: login, passwd: passwd}
		end
		session_user_ok?(ws_client)
	end

	def session_user_ok?(ws_client)
		@session_user_ok[ws_client]
	end

	#replacement of the following session_user_add
	def add_user_session(id,ws_client)
		ret={ok: true, msg: ""}
		if session_user_ok?(ws_client)
			user=@session_users[ws_client][:login]
			if @sessions[id][:users].include? user
				ret = {ok: false, msg: "User #{user} already registered for session #{id}"}
			else
				user=@session_users[ws_client][:login]
				@sessions[id][:users] << user
				@sessions[id][:ws_clients][user] = ws_client
				if @ws_clients[ws_client] and @ws_clients[ws_client][:user]==user
					if @ws_clients[ws_client][:ids].include? id
						# has to never happen
						ret = {ok: false, msg: "BUG!!! User #{user} already registered for session #{id}"}
					else
						@ws_clients[ws_client][:ids] << id
					end
				else
					@ws_clients[ws_client]={:user => user, :ids => [id]}
				end
			end
		else
			ret = {ok: false, msg: "User #{user} not allowed for session #{id}"}
		end
		return ret
	end

	def session_user_add(id,ws_client,user,info=nil)
		if session_user_ok?(ws_client)
				@sessions[id][:users] << user
				@sessions[id][:ws_clients][user] = ws_client
				@sessions[id][:user_info][user] = info
				@ws_clients[ws_client]={:user => user, :id => id}
				ret={ok: true, msg: ""}
		end
	end

	def session_user_id(id,ws_client)
		(@ws_clients[ws_client][:ids].include? id) ? @ws_clients[ws_client][:user] : nil
	end

	def session_user_remove(ws_client)
		if @ws_clients[ws_client]
			user=@ws_clients[ws_client][:user]
			@ws_clients[ws_client][:ids].each do |id|
				##p [:remove_id,id]
				##p [:remove_ws,@ws_clients[ws_client]]
				@sessions[id][:users].delete(user)
				@sessions[id][:ws_clients].delete(ws_client)
				##@sessions[id][:user_info].delete(user)
			end
		end
	end

	def session_all_ws_clients(id)
		#p [:session_all_ws_clients,id,@sessions[id]]
		@sessions[id][:users].map{|user| @sessions[id][:ws_clients][user]}
	end

end
