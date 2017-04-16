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
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      context 'each question object' do
        %w(id title body created_at updated_at).each do |attr|
          it "contains attribute #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'responds with code 401 if request does not have access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'responds with code 401 if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '123456' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:comment) { create(:comment, commentable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'responds with code 200' do
        expect(response.status).to eq(200)
      end

      %w(id title body created_at updated_at user_id).each do |attr|
        it "contains attribute #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it 'contains answers list' do
        expect(response.body).to have_json_size(1).at_path('question/answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "each answer contains attribute #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
        end
      end

      it 'contains attachments list' do
        expect(response.body).to have_json_size(1).at_path('question/attachments')
      end

      it 'each attachment contains attribute name' do
        expect(response.body).to be_json_eql('pic2.jpg'.to_json).at_path('question/attachments/0/name')
      end

      it 'each attachment contains attribute src' do
        expect(response.body).to be_json_eql("/uploads/attachment/file/#{attachment.id}/pic2.jpg".to_json)
                                     .at_path('question/attachments/0/src')
      end

      it 'contains comments list' do
        expect(response.body).to have_json_size(1).at_path('question/comments')
      end

      %w(id body created_at updated_at).each do |attr|
        it "each comment contains attribute #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      context 'when request does not have access_token' do
        it 'responds with code 401' do
          post '/api/v1/questions', params: { format: :json, question: attributes_for(:question) }
          expect(response.status).to eq(401)
        end

        it 'does not save question to db' do
          expect{ post '/api/v1/questions', params: { format: :json, question: attributes_for(:question) } }
              .to_not change(Question, :count)
        end
      end

      context 'when access_token is invalid' do
        it 'responds with code 401' do
          post '/api/v1/questions', params: { format: :json, access_token: '123456', question: attributes_for(:question) }
          expect(response.status).to eq(401)
        end

        it 'does not save question to db' do
          expect { post '/api/v1/questions',
                        params: { format: :json, access_token: '123456',
                                  question: attributes_for(:question) } }.to_not change(Question, :count)
        end
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'responds with code 201' do
          post '/api/v1/questions', params: { format: :json, access_token: access_token.token,
                                              question: attributes_for(:question) }
          expect(response.status).to eq(201)
        end

        it 'saves new question to db' do
          expect { post '/api/v1/questions',
                        params: { format: :json, access_token: access_token.token,
                                  question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'responds with code 422' do
          post '/api/v1/questions', params: { format: :json, access_token: access_token.token,
                                              question: attributes_for(:invalid_question) }
          expect(response.status).to eq(422)
        end

        it 'does not save new question to db' do
          expect { post '/api/v1/questions',
                        params: { format: :json, access_token: access_token.token,
                                  question: attributes_for(:invalid_question) } }.to_not change(user.questions, :count)
        end
      end
    end
  end
end