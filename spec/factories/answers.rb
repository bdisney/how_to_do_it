FactoryGirl.define do
  factory :answer do
    body "My Body Text"
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
  end
end
