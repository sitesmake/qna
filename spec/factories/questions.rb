FactoryGirl.define do
  factory :question do
    title "valid title"
    body "valid body"
    association :user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end

end
