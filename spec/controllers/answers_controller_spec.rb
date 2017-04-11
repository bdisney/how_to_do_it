require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_should_behave_like 'voted'

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  sign_in_user
  let!(:users_answer) { create(:answer, user: @user) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves answer to db' do
        expect { process :create, method: :post, params: { answer: attributes_for(:answer), question_id: question },
                         format: :json }.to change(@user.answers.where(question: question), :count).by(1)
      end

      it 'responds with json, status "created"' do
        process :create, method: :post, params: { answer: attributes_for(:answer), question_id: question }, format: :json
        expect(response.content_type).to eq('application/json')
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer to db' do
        expect { process :create, method: :post,
                         params: { answer: attributes_for(:invalid_answer), question_id: question },
                         format: :json }.to_not change(Answer, :count)
      end

      it 'responds with status 422' do
        process :create, method: :post, params: { answer: attributes_for(:invalid_answer), question_id: question },
                format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #edit' do
    context 'edit by author' do
      before { get :edit, xhr: true, params: { id: users_answer.id }, format: :js }

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq(users_answer)
      end

      it 'renders edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'edit by someone else' do
      before { get :edit, xhr: true, params: { id: answer.id }, format: :js }

      it 'responds with status 403 (forbidden)' do
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'PATCH #update' do
    context 'update by author with valid attributes' do
      before { process :update, method: :patch, params: { id: users_answer.id, answer: { body: 'new body' } },
                       format: :js }

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq(users_answer)
      end

      it 'saves new answer to db' do
        users_answer.reload
        expect(users_answer.body).to eq 'new body'
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'update by author with invalid attributes' do
      before { process :update, method: :patch, params: { id: users_answer.id, answer: { body: '' } },
                       format: :js }

      it 'does not save new answer to db' do
        users_answer.reload
        expect(users_answer.body).to match /^answer_body_\d+$/
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'update by someone else' do
      it 'responds with status 403 (forbidden)' do
        process :update, method: :patch, params: { id: answer.id, answer: attributes_for(:answer) }, format: :js
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'PATCH #accept' do
    context 'accept by author of question' do
      let(:users_question) { create(:question, user: @user) }
      let(:new_answer) { create(:answer, question: users_question, user: create(:user)) }

      before { process :accept, method: :patch, params: { id: new_answer.id }, format: :js }

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq(new_answer)
      end

      it 'make answer accepted' do
        new_answer.reload
        expect(new_answer).to be_accepted
      end

      it 'renders update template' do
        expect(response).to render_template :accept
      end
    end

    context 'accept by someone else' do
      let(:unknown_user) { create(:user) }
      let(:someones_question) { create(:question, user: unknown_user) }
      let!(:someones_answer) { create(:answer, question: someones_question) }

      before { process :accept, method: :patch, params: { id: someones_answer.id }, format: :js }

      it 'do not make answer accepted' do
        expect(someones_answer.reload).to_not be_accepted
      end

      it 'responds with status 403 (forbidden)' do
        expect(response.status).to eq(403)
      end
    end
  end


  describe 'DELETE #destroy' do
    context 'delete by author' do
      it 'deletes answer from db' do
        expect { process :destroy, method: :delete, params: { id: users_answer.id }, format: :json }
            .to change(Answer, :count).by(-1)
      end
    end

    context 'delete by someone else' do
      it 'does not delete answer from db' do
        expect { process :destroy, method: :delete, params: { id: answer.id }, format: :js }
            .to_not change(Answer, :count)
      end

      it 'responds with status 403 (forbidden)' do
        process :destroy, method: :delete, params: { id: answer.id }, format: :json
        expect(response.status).to eq(403)
      end
    end
  end
end