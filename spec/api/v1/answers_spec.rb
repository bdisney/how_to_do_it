require 'rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /index' do
    let(:question) { create(:question) }
    let(:http_method) { :get }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }

    it_should_behave_like 'API authorized'

    let!(:answers) { create_list(:answer, 2, question: question) }
    let!(:answer) { answers.first }

    before { get path, params: { format: :json, access_token: access_token.token } }

    it 'returns answers list' do
      expect(response.body).to have_json_size(2).at_path('answers')
    end

    context 'each answer object' do
      %w(id body created_at updated_at).each do |attr|
        it "contains attribute #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer) }
    let(:http_method) { :get }
    let(:path) { "/api/v1/answers/#{answer.id}" }

    it_should_behave_like 'API authorized'

    let(:attachable) { answer }
    it_should_behave_like 'API attached'

    let(:commentable) { answer }
    it_should_behave_like 'API commented'

    context 'authorized' do
      before { get path, params: { format: :json, access_token: access_token.token } }

      %w(id body created_at updated_at user_id).each do |attr|
        it "contains attribute #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end
  end

  describe 'POST /create' do
    let!(:question) { create(:question) }
    let(:http_method) { :post }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }
    let(:params) { { question_id: question, answer: attributes_for(:answer) } }

    it_should_behave_like 'API authorized'

    context 'unauthorized' do
      context 'when request does not have access_token' do
        it 'does not save answer to db' do
          expect{ post path, params: { format: :json, question_id: question, answer: attributes_for(:answer) } }
              .to_not change(Answer, :count)
        end
      end

      context 'when access_token is invalid' do
        it 'does not save answer to db' do
          expect { post path, params: { format: :json, access_token: '123456', question_id: question,
                                        answer: attributes_for(:answer) } }.to_not change(Answer, :count)
        end
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'saves new question to db' do
          expect { post path, params: { format: :json, access_token: access_token.token, question_id: question,
                                        answer: attributes_for(:answer) } }
              .to change(user.answers.where(question: question), :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'responds with code 422' do
          post path, params: { format: :json, access_token: access_token.token, question_id: question,
                               answer: attributes_for(:invalid_answer) }
          expect(response.status).to eq(422)
        end

        it 'does not save new question to db' do
          expect { post path, params: { format: :json, access_token: access_token.token, question_id: question,
                                        answer: attributes_for(:invalid_answer) } }
              .to_not change(Answer, :count)
        end
      end
    end
  end
end