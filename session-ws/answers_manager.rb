## Questions: peut être lent et placé directement dans le fichier "questions".
## A chaque session ce fichier est chargé en début et à chaque envoi d'une question aux utilisateurs...

## Answers: correspond aux résultats d'une session relative au questionnaire.
## Il peut y en avoir plusieurs pour un même questionnaire.
## Les résultats sont sauvegardés assez souvent.
## Ainsi, en cas de panne, l'état de la session sera rétablie après réouverture de ce fichier.
require 'fileutils'
require './mongoid_utils'

class Answers

	include MongoidUtils

	@@mngr=nil

	def Answers.mngr
		@@mngr=self.new unless @@mngr
		@@mngr
	end

	def initialize
		@session_ids=[]
		@root_session=File.expand_path(File.join(File.dirname(__FILE__),"session"))
		@answer_id={} #by session_id (correspond to passwd)
		@questions={}
		@answers={}
		@session_wdir={}
	end

	def init_session(id,passwd)
		if id
			@answer_id[id]=passwd
			@session_ids << id
			@session_ids.uniq!
		end
	end

	def session_id(id)
		id[1..-1]
	end

	def session_active(id)
		@session_ids.include? id
	end

	def user_answer_filename(id,user)
		File.join(@session_wdir[id],user)
	end

	@@question_form_index=".question_form_index"

	def load_form_list(html=true)
		filename=File.join(@root_session,@@question_form_index)
  		form_list=(File.exist? filename) ? eval(File.read(filename)) : []
		if html
			form_list.map! do |id|
				"<option value='"+id.strip+"'>"+id+"</option>"
			end
			form_list=form_list.join("\n")
		end
		form_list
	end

	def load_question_list(id,html=true)
		question_list=nil
		if @questions and @questions[id]
			question_list=@questions[id][:ids].dup
			if html
				question_list.map! do |qid|
					"<option value='"+qid.strip+"'>"+qid+"</option>"
				end
				question_list=question_list.join("\n")
			end
		end
		question_list
	end

	def load_questions(id,passwd,creation_time)
		return unless id
		init_session(id,passwd)
		if session_active(id)
			filename=File.join(@root_session,session_id(id),"questions")
			@questions[id]=eval(File.read(filename)) if File.exist? filename
		end
		## when questions loaded
		@answers[id]={}
		@session_wdir[id]=File.join(@root_session,"answers",session_id(id),creation_time+"_"+passwd)
		FileUtils.mkdir_p(@session_wdir[id])
		## @questions[:ids],@questions[:questions]
		@questions[id]
	end

	def reload_questions(id)
		return unless id
		if session_active(id)
			filename=File.join(@root_session,session_id(id),"questions")
			@questions[id]=eval(File.read(filename)) if File.exist? filename
		end
		## @questions[:ids],@questions[:questions]
		@questions[id]
	end

	def init_user_answer(id,user)
		filename=user_answer_filename(id,user)
		@answers[id][user]=(File.exist? filename) ?  eval(File.read(filename)) : {}
	end

	def set_user_answer(id,user,qid,answer)
		init_user_answer(id,user)
		@answers[id][user][qid] = answer
		save_user_answer(id,user)
	end

	## answers are save by answer and user in one file
	## in the subdir <session_id>/<answer_id>
	def save_user_answer(id,user)
		# filename=user_answer_filename(id,user)
		# File.open(filename,"w") do |f|
		# 	f << @answers[id][user].inspect
		# end
		ok=false
		if mongoid? :QuestionForm
			if (question_form=Session.mngr.question_form?)
				if (current_user_answers=question_form.user_answers.select {|e| e.login ==user}.last)
					 @answers[id][user]=(current_user_answers.question_answers).merge(@answers[id][user])
					current_user_answers.update_attributes({question_answers: @answers[id][user]})
				else
					question_form.user_answers.create({login: user,question_answers: @answers[id][user]})
				end
				ok=true
			end
		end
		return ok
	end

	def get_question_answers(id,qid)
		answers={}
		if @questions[id][:ids].include? qid
			session_show(id).each do |user|
				answers[user]=@answers[id][user][qid]
			end
		end
		answers
	end

end
