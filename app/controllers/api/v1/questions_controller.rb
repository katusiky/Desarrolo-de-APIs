class Api::V1::QuestionsController < Api::V1::MasterApiController
	before_action :authenticate, except: [:index, :show]
	before_action :set_poll
	before_action :set_question, except: [:index, :create]
	before_action(only: [:update, :destroy, :create]) { |controlador| controlador.authenticate_owner(@poll.user) }

	def index
		@questions = @poll.questions
	end

	def show
		
	end

	def create
		@question = @poll.questions.new questions_params
		if @question.save
			render "api/v1/questions/show"
		else
			error_array!( @question.errors.full_messages, :unprocessable_entity)
		end
	end

	def update
		@question.update questions_params
		render "api/v1/questions/show"
	end

	def destroy
		@question.destroy
		head :ok
	end

	private

	def set_poll
		@poll = MyPoll.find params[:poll_id] 
	end

	def questions_params
		params.permit(:description)
	end

	def set_question
		@question = Question.find params[:id]
	end
end