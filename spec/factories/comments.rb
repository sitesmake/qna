FactoryGirl.define do
  factory :comment do
    user
    association :commentable, factory: :question
		body "comment text"
  end

end
