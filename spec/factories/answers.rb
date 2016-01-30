FactoryGirl.define do
  factory :answer do
    association :question
    body "Answer text"
    association :user
  end
end
