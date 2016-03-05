class Api::V1::AnswersController < ApplicationController
	
	before_action :authenticate, only: [:create, :update, :destroy]
	before_action :set_poll, only: [:update, :destroy]
	before_action :set_answer, only: [:update, :destroy]
	before_action(only: [:update, :destroy]) { |controlador| controlador.authenticate_owner(@poll.user) }
	
	def create
		@answer = Answer.new answers_params
		if @answer.save
			render "api/v1/answers/show"
		else
			render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def update
		@answer.update answers_params
		render "api/v1/answers/show"
	end

	def destroy
		@answer.destroy
		head :ok
	end

	private

	def set_poll
		@poll = MyPoll.find params[:poll_id] 
	end

	def answers_params
		params.require(:answer).permit(:description, :question_id)
	end

	def set_answer
		@answer = Answer.find params[:id]
	end
end