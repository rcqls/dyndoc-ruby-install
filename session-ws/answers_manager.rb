## Questions: peut être lent et placé directement dans le fichier "questions".
## A chaque session ce fichier est chargé en début et à chaque envoi d'une question aux utilisateurs...

## Answers: correspond aux résultats d'une session relative au questionnaire. 
## Il peut y en avoir plusieurs pour un même questionnaire. 
## Les résultats sont sauvegardés assez souvent. 
## Ainsi, en cas de panne, l'état de la session sera rétablie après réouverture de ce fichier.
require 'fileutils'

class Answers

	@@mngr=nil

	def Answers.mngr
		@@mngr=self.new unless @@mngr
		@@mngr
	end

	def initialize
		@session_ids=[]
		@root_session=File.expand_path("./session")
		@answer_id={} #by session_id (correspond to passwd)
		@questions={}
		@answers={}
		@session_wdir={}
	end

	def init_session(id)
		if id
			@answer_id[id]=Session.mngr.session_answer_id(id)
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

	def load_questions(id)
		return unless id
		init_session(id)
		if session_active(id)
			filename=File.join(@root_session,session_id(id),"questions")
			@questions[id]=eval(File.read(filename)) if File.exist? filename
		end
		## when questions loaded
		@answers[id]={}
		@session_wdir[id]=File.join(@root_session,session_id(id),".answers",@answer_id[id])
		FileUtils.mkdir_p(@session_wdir[id])
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
		save_user_answer(id,passwd,user)
	end

	## answers are save by answer and user in one file
	## in the subdir <session_id>/<answer_id>
	def save_user_answer(id,user)
		filename=user_answer_filename(id,user)
		File.open(filename,"w") do |f|
			f << @answers[id][user].inspect
		end
	end

	def get_question_answers(id,qid)
		answers={}
		@questions[id][:ids].each do |qid|
			answers[id]=@answers[id][user][qid]
		end
		answers
	end

end