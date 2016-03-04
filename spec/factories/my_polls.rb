FactoryGirl.define do
  factory :my_poll do
    association :user, factory: :sequence_user
    expires_at "2016-03-02 11:18:58"
    title "MyString12"
    description "MyString12MyString12"
  end
end
