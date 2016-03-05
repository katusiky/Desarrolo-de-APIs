require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should_not allow_value("josedeleon.ka@gmail").for(:email) }
  it { should allow_value('josedeleon.ka@gmail.com').for(:email) }
  it { should validate_presence_of(:uid) }
  it { should validate_presence_of(:provider) }

  it "debería crear un usuario si el uid y el provider no existen" do
  	expect{
  		User.from_omniauth({uid: '123456', provider: 'facebookk', info: {email: 'josee@gmail.com'}})
  	}.to change(User, :count).by(1)
  end

  it "debería buscar un usuario si el uid y el provider ya existen" do
  	user = FactoryGirl.create(:user)
  	expect{
  		User.from_omniauth({uid: user.uid, provider: user.provider})
  	}.to change(User, :count).by(0)
  end

  it 'debería retornar el usuario encontrado si el uid y el provider ya existen' do
  	user = FactoryGirl.create(:user)
  	expect(
  		User.from_omniauth({uid: user.uid, provider: user.provider})
  	).to eq(user)
	end
end
