FactoryGirl.define do
  sequence :body do |n|
    "Answer text #{n}"
  end

  factory :answer do
    association :question
    body
    association :user
  end
end
