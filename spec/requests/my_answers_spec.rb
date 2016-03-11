require 'rails_helper'

RSpec.describe Api::V1::MyAnswersController, type: :request do
	
	before :each do 
		@my_app = FactoryGirl.create(:my_app, user: FactoryGirl.create(:sequence_user))
		@token = FactoryGirl.create(:token, expires_at: DateTime.now + 20.month, my_app: @my_app )
		@poll = FactoryGirl.create(:poll_with_questions, user: @token.user)
		@question = FactoryGirl.create(:question, my_poll: @poll)
		@answer = FactoryGirl.create(:answer, question: @question)
	end

	let(:valid_params){ { my_poll_id: @poll.id, answer_id: @answer.id, token: @token.token, secret_key: @my_app.secret_key } }

	describe "POST /polls/:poll_id/answers" do
		before :each do
			post api_v1_my_answers_path, valid_params
		end

		it { expect(response).to have_http_status(200)}

		it "debería crear una respuesta" do
			puts "#\n\n\n #{response.body}\n\n\n"
			json = JSON.parse(response.body)
			expect(json["data"]["id"]).to eq(MyAnswer.last.id)
		end
	end 
end