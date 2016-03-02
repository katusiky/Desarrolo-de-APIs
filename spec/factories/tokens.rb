FactoryGirl.define do
  factory :token do
    expires_at "2016-03-02 11:18:58"
    association :user, factory: :user
  end
end
