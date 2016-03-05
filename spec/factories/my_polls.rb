FactoryGirl.define do
  factory :my_poll do
    association :user, factory: :sequence_user
    expires_at "2016-03-02 11:18:58"
    title "MyString12"
    description "MyString12MyString12"
    factory :poll_with_questions do
			title "Poll With Questions"
    	description "MyStri ng12 MyStri ng12"
    	questions { build_list :question, 2 }
		end
  end
end
