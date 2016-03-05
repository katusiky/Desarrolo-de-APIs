FactoryGirl.define do
  factory :user do
    email "josedeleon.kaasdsa@gmail.com"
    name "José"
    provider "github"
    uid "asd2as4dasdas544"
    factory :bad_user do
	    email "alberto.ksadasdas@gmail.com"
	    name "alberto"
	    provider "facebook"
	    uid "asd2as4dasdas544"
    end
    factory :sequence_user do
    	sequence(:email) { |n| "person#{n}@example.com"}
	    name "alberto"
	    provider "facebook"
	    uid "asd2as4dasdas544"
    end
  end
end
