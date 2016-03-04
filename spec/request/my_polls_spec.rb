require 'rails_helper'

RSpec.describe Api::V1::MyPollsController, type: :request do
	describe 'GET /polls' do
		before :each do 
			FactoryGirl.create_list(:my_poll, 10)
			get '/api/v1/polls'
		end
		
		it { expect(response).to have_http_status(200) }
		it 'mande la lista de encuestas' do
			json = JSON.parse(response.body)
			expect(json.length).to eq(MyPoll.count)
		end
	end

	describe 'GET /polls/:id' do
		before :each do 
			@poll = FactoryGirl.create(:my_poll)
			get "/api/v1/polls/#{@poll.id}"
		end

		it { expect(response).to have_http_status(200) }
		it 'mande la encuesta solicitada' do
			json = JSON.parse(response.body)
			expect(json['id']).to eq(@poll.id)
		end
		it 'mande la encuesta del usuario solicitado' do
			json = JSON.parse(response.body)
			expect(json['user_id']).to eq(@poll.user_id)
		end
		it "manda las claves correctas" do
			json = JSON.parse(response.body)
			expect(json.keys).to contain_exactly('id','title','description','expires_at','user_id')
		end
	end

	describe 'POST /polls' do
		context 'con token válido' do
			before :each do 
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				post "/api/v1/polls", {token: @token.token, title: "Hola Mundo", description: "asdasd asd asdasd asdasdas", expires_at: DateTime.now}
			end

			it { expect(response).to have_http_status(200) }
			it 'crea una nueva encuesta' do
				expect{
					post "/api/v1/polls", {token: @token.token, title: "Hola Mundo", description: "asdasd asd asdasd asdasdas", expires_at: DateTime.now}
					}.to change(MyPoll,:count).by(1)
			end
			it "responde con la encuesta creada" do
				json = JSON.parse(response.body)
				expect(json["title"]).to eq("Hola Mundo")
			end
		end


		context 'con token inválido' do
			before :each do
				post "/api/v1/polls"
			end

			it { expect(response).to have_http_status(401) }
			it "responde con los errores al guardar la encuesta" do
				json = JSON.parse(response.body)
				expect(json["error"]).to_not be_empty
			end
		end

		context 'parámetros inválidos' do
			before :each do 
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				post "/api/v1/polls", {token: @token.token, title: "Hola Mundo",
															 expires_at: DateTime.now}
			end

			it { expect(response).to have_http_status(422) }
			it "responde con los errores al guardar la encuesta" do
				json = JSON.parse(response.body)
				expect(json["errors"]).to_not be_empty
			end

		end
	end

	describe 'PATCH /polls/:id' do
		context 'con un token válido' do
			before :each do 
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: @token.user)
				patch api_v1_poll_path(@poll), {token: @token.token, title: "Nuevo Titulo" }
			end

			it { expect(response).to have_http_status(200) }
			it "actualizar la encuenta" do
				json = JSON.parse(response.body)
				expect(json["title"]).to eq("Nuevo Titulo")
			end
			#it "retornar con la encuesta actualizada"
		end

		context 'con un token inválido' do
			before :each do 
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: FactoryGirl.create(:bad_user))
				patch api_v1_poll_path(@poll), {token: @token.token, title: "Nuevo Titulo" }
			end

			it { expect(response).to have_http_status(401) }
		end
	end

	describe 'DELETE /polls/:id' do
		context 'con un token válido' do
			before :each do 
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: @token.user)
			end

			it 'esperando que se elimine la encuesta' do 
				delete api_v1_poll_path(@poll), {token: @token.token}
				expect(response).to have_http_status(200) 
			end

			it "eliminar la encuenta" do
				expect{
					delete api_v1_poll_path(@poll), {token: @token.token}
					}.to change(MyPoll,:count).by(-1)
			end
		end

		context 'con un token inválido' do
			before :each do 
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: FactoryGirl.create(:bad_user))
			end

			it "esperando que no me deje borrar" do 
				delete api_v1_poll_path(@poll), {token: @token.token}
				expect(response).to have_http_status(401) 
			end
		end
	end
end