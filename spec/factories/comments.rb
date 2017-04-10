FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "comment_body_#{n}" }
    user
    association :commentable, factory: :question

    factory :invalid_comment do
      body nil
    end
  end
end