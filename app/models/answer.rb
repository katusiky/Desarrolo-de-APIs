class Answer < ActiveRecord::Base
  belongs_to :question

  has_many :my_answers

  validates :description, presence: true
  validates :question, presence: true
end
