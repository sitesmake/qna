FactoryGirl.define do
  factory :vote do
    user
    voice 1
    association :votable, factory: :question
  end

end
