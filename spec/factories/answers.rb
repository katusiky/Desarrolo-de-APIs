FactoryGirl.define do
  factory :answer do
    association :question, factory: :question
    description "Mi respuesta de prueba"
  end
end
