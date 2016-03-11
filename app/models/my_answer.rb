class MyAnswer < ActiveRecord::Base
  belongs_to :user_poll
  belongs_to :answer
  belongs_to :question

  validates_presence_of :answer, :user_poll

  def self.custom_update_or_create user_poll, answer
  	my_answer = where(user_poll: user_poll, question: answer.question, answer: answer).first_or_create
  	
  	my_answer.update(answer: answer)

  	my_answer
  end
end
