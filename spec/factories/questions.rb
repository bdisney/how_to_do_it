FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "question_title_#{n}" }
    sequence(:body) { |n| "question_body_#{n}" }
    user

    factory :question_with_answers do
      transient do
        answers_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end

    factory :invalid_question, class: 'Question' do
      title nil
      body nil
      user
    end
  end
end
