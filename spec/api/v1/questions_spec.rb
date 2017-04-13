require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'responds with code 401 if request does not have access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'responds with code 401 if access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '123456' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'responds with code 200' do
        expect(response.status).to eq(200)
      end

      it 'returns questions list' do
        expect(response.body).to have_json_size(2)
      end

      context 'each question object' do
        %w(id title body created_at updated_at).each do |attr|
          it "contains attribute #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
          end
        end

        it 'contains answers list' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "each answer contains attribute #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end
end