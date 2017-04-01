FactoryGirl.define do
  factory :question do
    title "Hello world!"
    body "My question body"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
