FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "comment_body_#{n}" }
    user
    association :commentable, factory: :question
  end
end