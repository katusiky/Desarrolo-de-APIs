class UserPoll < ActiveRecord::Base
  belongs_to :user
  belongs_to :my_poll

  has_many :my_answers

  validates_presence_of :my_poll, :user

  def self.custom_find_or_create poll, user
  	where(my_poll: poll, user: user).first_or_create
  end

end
