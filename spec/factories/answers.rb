FactoryGirl.define do
  sequence :body do |n|
    "Answer text #{n}"
  end

  factory :answer do
    question
    body
    user
  end
end
