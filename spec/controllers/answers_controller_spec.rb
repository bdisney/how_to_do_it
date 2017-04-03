require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  sign_in_user
  let!(:users_answer) { create(:answer, user: @user) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves answer to db' do
        expect { process :create, method: :post, params: { answer: attributes_for(:answer), question_id: question },
                         format: :js }.to change(@user.answers.where(question: question), :count).by(1)
      end

      it 'renders create template' do
        process :create, method: :post, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer to db' do
        expect { process :create, method: :post,
                         params: { answer: attributes_for(:invalid_answer), question_id: question },
                         format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template with error messages' do
        process :create, method: :post, params: { answer: attributes_for(:invalid_answer), question_id: question },
                format: :js
        expect(response).to render_template :create
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

      it 'redirects to related question page' do
        expect(response).to redirect_to question
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
      it 'redirects to related question page' do
        process :update, method: :patch, params: { id: answer.id, answer: attributes_for(:answer) }, format: :js
        expect(response).to redirect_to question
      end
    end
  end


  describe 'DELETE #destroy' do
    context 'delete by author' do
      it 'deletes answer from db' do
        expect { process :destroy, method: :delete, params: { id: users_answer.id }, format: :js }
            .to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        process :destroy, method: :delete, params: { id: users_answer.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'delete by someone else' do
      it 'does not delete answer from db' do
        expect { process :destroy, method: :delete, params: { id: answer.id }, format: :js }
            .to_not change(Answer, :count)
      end

      it 'redirects to related question page' do
        process :destroy, method: :delete, params: { id: answer.id }, format: :js
        expect(response).to redirect_to question
      end
    end
  end
end