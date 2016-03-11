require 'rails_helper'

RSpec.describe MyApp, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }

  it "debería generar un app_id" do
  	my_app = FactoryGirl.create(:my_app)
  	expect(my_app.app_id).to_not be_nil
  end

  it "debería generar un secret_key" do
  	my_app = FactoryGirl.create(:my_app)
  	expect(my_app.secret_key).to_not be_nil
  end

  it "debería poder encontrar sus propios tokens" do
  	my_app = FactoryGirl.create(:my_app)
  	token = FactoryGirl.create(:token, my_app: my_app, user: my_app.user)
  	expect(my_app.is_your_token?(token)).to eq(true)
  end

  it "debería retornar false" do
  	my_app = FactoryGirl.create(:my_app)
  	your_app = FactoryGirl.create(:my_app, user: my_app.user)
  	token = FactoryGirl.create(:token, my_app: your_app, user: my_app.user)
  	expect(my_app.is_your_token?(token)).to eq(false)
  end
end
