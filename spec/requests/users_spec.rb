require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
	describe 'POST /users' do

		let(:my_app){ FactoryGirl.create(:my_app, user: FactoryGirl.create(:sequence_user))}

		before :each do
			auth = {provider: 'google', uid:'1234567', info: {email: 'j@gmail.com'} }
 			post "/api/v1/users", {auth: auth, secret_key: my_app.secret_key}
		end

		it { expect(response).to have_http_status(200) }

		it { change(User, :count).by(1) }

		it 'responds with the user found or created' do
			json = JSON.parse(response.body)
			puts "#{json}"
			expect(json['data']['attributes']['email']).to eq('j@gmail.com')
		end

		it "responds with the token" do
			token = Token.last
			expect(token.my_app).to_not be_nil
		end
	end
end