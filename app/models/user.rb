class User < ActiveRecord::Base
	has_many :tokens
	has_many :my_polls
	has_many :my_apps

	validates :email, presence: true, email: true, uniqueness: true
	validates :uid, presence: true
	validates :provider, presence: true

	def self.from_omniauth(data)

		User.where(provider: data[:provider], uid: data[:uid]).first_or_create do |user|
			user.email = data[:info][:email]
		end

	end
end
