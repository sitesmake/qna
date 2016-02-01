FactoryGirl.define do
  sequence :title do |n|
    "valid title #{n}"
  end

  sequence :question_body do |n|
    "valid body #{n}"
  end

  factory :question do
    title
    body { generate(:question_body) }
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end

end
