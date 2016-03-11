FactoryGirl.define do
  factory :user_poll do
  	association :user, factory: :bad_user
  	association :my_poll, factory: :my_poll
  end
end
