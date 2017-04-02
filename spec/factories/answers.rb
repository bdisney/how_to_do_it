FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "answer_body_#{n}" }
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
    user nil
  end
end
