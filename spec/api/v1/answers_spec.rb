require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'responds with code 401 if request does not have access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'responds with code 401 if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '123456' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'responds with code 200' do
        expect(response.status).to eq(200)
      end

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
  end

  describe 'GET /show' do
    let(:answer) { create(:answer) }
    let!(:attachment) { create(:attachment, attachable: answer) }
    let!(:comment) { create(:comment, commentable: answer) }

    context 'unauthorized' do
      it 'responds with code 401 if request does not have access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'responds with code 401 if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '123456' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'responds with code 200' do
        expect(response.status).to eq(200)
      end

      %w(id body created_at updated_at user_id).each do |attr|
        it "contains attribute #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it 'contains attachments list' do
        expect(response.body).to have_json_size(1).at_path('answer/attachments')
      end

      it 'each attachment contains attribute name' do
        expect(response.body).to be_json_eql('pic2.jpg'.to_json).at_path('answer/attachments/0/name')
      end

      it 'each attachment contains attribute src' do
        expect(response.body).to be_json_eql("/uploads/attachment/file/#{attachment.id}/pic2.jpg".to_json)
                                     .at_path('answer/attachments/0/src')
      end

      it 'contains comments list' do
        expect(response.body).to have_json_size(1).at_path('answer/comments')
      end

      %w(id body created_at updated_at).each do |attr|
        it "each comment contains attribute #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
        end
      end
    end
  end
end