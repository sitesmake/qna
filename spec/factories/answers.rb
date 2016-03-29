FactoryGirl.define do
  sequence :body do |n|
    "Answer text #{n}"
  end

  factory :answer do
    question
    body
    user
  end

  factory :invalid_answer, class: 'Answer' do
    question
    user
    body nil
  end
end
