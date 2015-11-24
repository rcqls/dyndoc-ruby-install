class SessionMngr

	def initialize
		@sessions = {}
		@ws_clients = {}
	end

	def session_new(id,passwd)
		@sessions[id] = {:users=>[],:user_info => {},:ws_clients => {},:passwd => passwd}
	end

	def session_remove(id)
		if @sessions.keys.include? id
			@sessions.delete id
		end
	end

	def session_ok?(id,passwd)
		@sessions[id][:passwd] == passwd
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

	def is_session?(id)
		session_ls.include? id
	end

	def session_show(id)
		@sessions[id][:users]
	end

	def session_user_add(id,ws_client,user,info=nil)
		@sessions[id][:users] << user
		@sessions[id][:ws_clients][user] = ws_client
		@sessions[id][:user_info][user] = info
		@ws_clients[ws_client]={:user => user, :id => id}
	end

	def session_user_remove(ws_client)
		if @ws_clients[ws_client]
			id=@ws_clients[ws_client][:id]
			p [:remove_id,id]
			p [:remove_ws,@ws_clients[ws_client]]
			user=@ws_clients[ws_client][:user]
			@sessions[id][:users].delete(user)
			@sessions[id][:ws_clients].delete(ws_client)
			@sessions[id][:user_info].delete(user)
		end
	end

	def session_all_ws_clients(id)
		@sessions[id][:users].map{|user| @sessions[id][:ws_clients][user]}
	end

end