require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :request do
	
	before :each do 
		@token = FactoryGirl.create(:token, expires_at: DateTime.now + 20.month )
		@poll = FactoryGirl.create(:poll_with_questions, user: @token.user)
		@question = @poll.questions[0]
	end

	let(:valid_params){{description: 'Ruby on Rails', question_id: @question.id}}

	describe "POST /polls/:poll_id/answers" do
		context "con usuario válido" do 
			before :each do 
				@question = @poll.questions[0]
				post api_v1_poll_answers_path(@poll), { answer: valid_params, token: @token.token}
			end
			it { expect(response).to have_http_status(200) }

			it "aumentan las respuestas" do
				expect{
					post api_v1_poll_answers_path(@poll), { answer: valid_params, token: @token.token}
				}.to change(Answer,:count).by(1)
			end

			it "responde con la respuesta creada" do
				json = JSON.parse(response.body)
				expect(json["description"]).to eq(valid_params[:description])
			end
		end
	end 

	describe "PUT/PATCH  /polls/:poll_id/answers/:id" do
		before :each do 
			@answer = FactoryGirl.create(:answer, question: @question)
			put api_v1_poll_answer_path(@poll, @answer),{ answer: { description: "Nueva Respuesta"},
																										 token: @token.token}
		end

		it { expect(response).to have_http_status(200) }

		it 'actualiza la respuesta' do
			@answer.reload 
			expect(@answer.description).to eq('Nueva Respuesta')
		end
	end

	describe "DELETE  /polls/:poll_id/answers/:id" do
		before :each do 
			@answer = FactoryGirl.create(:answer, question: @question)
		end

		it "status 200" do 
			delete api_v1_poll_answer_path(@poll, @answer), {token: @token.token} 
			expect(response).to have_http_status(200) 
		end
		
		it 'elimina la respuesta' do 
			delete api_v1_poll_answer_path(@poll, @answer), {token: @token.token}
			expect(Answer.where(id: @question.id)).to be_empty
		end

		it 'reduce cantidad de respuesta' do
			expect{
				delete api_v1_poll_answer_path(@poll, @answer), {token: @token.token}
			}.to change(Answer, :count).by(-1)
		end
	end
end