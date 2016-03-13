FactoryGirl.define do
  factory :comment do
    user nil
commentable_id 1
commentable_type "MyString"
body "MyText"
  end

end
