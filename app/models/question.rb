class Question < ActiveRecord::Base
  belongs_to :my_poll

  has_many :answers
  has_many :my_answers

  validates :description, presence: true, length: {minimum: 10, maximum: 120}
  validates :my_poll, presence: true 
end
