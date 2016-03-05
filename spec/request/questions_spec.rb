require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :request do
	
	before :each do 
		@token = FactoryGirl.create(:token, expires_at: DateTime.now + 20.month )
		@poll = FactoryGirl.create(:poll_with_questions, user: @token.user)
	end

	describe 'GET /polls/:poll_id/questions' do
		before :each do 
			get "/api/v1/polls/#{@poll.id}/questions"
		end

		it { expect(response).to have_http_status(200) }
		it 'mande la lista de preguntas para la encuesta' do
			json = JSON.parse(response.body)
			expect(json.length).to eq(@poll.questions.count)
		end

		it "manda la descipcion y id" do
			json_array = JSON.parse(response.body)
			question = json_array[0]
			expect(question.keys).to contain_exactly('id','description')
		end
	end

	describe "POST /polls/:poll_id/questions" do
		context "con usuario válido" do 
			before :each do 
				post api_v1_poll_questions_path(@poll), 
												{description: '¿te gusta el curso de apis?',
												token: @token.token}
			end
			it { expect(response).to have_http_status(200) }

			it "aumentan las preguntas" do
				expect{
					post api_v1_poll_questions_path(@poll), 
													{description: '¿te gusta el curso de apis?',
													token: @token.token}
				}.to change(Question,:count).by(1)
			end

			it "responde con la pregunta creada" do
				json = JSON.parse(response.body)
				expect(json["description"]).to eq("¿te gusta el curso de apis?")
			end
		end

		context "con usuario inválido" do  
			before :each do 
				@new_token = FactoryGirl.create :token, user: @new_user, expires_at: DateTime.now + 20.month  
				@new_user = FactoryGirl.create :bad_user
				post api_v1_poll_questions_path(@poll), 
												{description: '¿te gusta el curso de apis?',
												token: @new_token.token}
			end
			it { expect(response).to have_http_status(401) }

			it "no aumentan las preguntas" do
				expect{
					post api_v1_poll_questions_path(@poll), 
													{description: '¿te gusta el curso de apis?',
													token: @new_token.token}
				}.to change(Question,:count).by(0)
			end
		end
	end

	describe "GET /polls/:poll_id/questions/:id" do
		before :each do 
			@question = @poll.questions[0]
			get api_v1_poll_question_path(@poll, @question)
		end

		it { expect(response).to have_http_status(200) }

		it "retorne la pregunta solicitada" do
			json = JSON.parse(response.body)
			expect(json["description"]).to eq(@question.description)
			expect(json["id"]).to eq(@question.id)
		end
	end

	describe "PUT/PATCH  /polls/:poll_id/questions/:id" do
		before :each do 
			@question = @poll.questions[0]
			patch api_v1_poll_question_path(@poll, @question), 
											{description: '¿te gusta el curso?',
											token: @token.token}
		end

		it { expect(response).to have_http_status(200) }

		it 'actualiza la pregunta' do 
			json = JSON.parse(response.body)
			expect(json["description"]).to eq('¿te gusta el curso?')
		end
	end

	describe "DELETE  /polls/:poll_id/questions/:id" do
		before :each do 
			@question = @poll.questions[0]
		end

		it "status 200" do 
			delete api_v1_poll_question_path(@poll, @question), {token: @token.token} 
			expect(response).to have_http_status(200) 
		end
		
		it 'elimina la pregunta' do 
			delete api_v1_poll_question_path(@poll, @question), {token: @token.token}
			expect(Question.where(id: @question.id)).to be_empty
		end

		it 'reduce cantidad de questions' do
			expect{
				delete api_v1_poll_question_path(@poll, @question), {token: @token.token}
			}.to change(Question, :count).by(-1)
		end
	end
end