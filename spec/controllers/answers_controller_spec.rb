require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, params: { question_id: question } }

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders the new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save answer to db' do
        expect { process :create, method: :post, params: { answer: attributes_for(:answer), question_id: question } }
            .to change(question.answers, :count).by(1)
      end

      it 'redirects to related question' do
        process :create, method: :post, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer to db' do
        expect { process :create, method: :post, params: { answer: attributes_for(:invalid_answer), question_id: question } }
            .to_not change(Answer, :count)
      end

      it 'render new view' do
        process :create, method: :post, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
  
    context 'delete by author' do
      let!(:answer) { create(:answer, user: @user) }
  
      it 'deletes answer from db' do
        expect { process :destroy, method: :delete, params: { id: answer.id } }
            .to change(Answer, :count).by(-1)
      end

      it 'redirects to related question page' do
        process :destroy, method: :delete, params: { id: answer.id }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'delete by someone else' do
      let!(:answer) { create(:answer, user: create(:user)) }

      it 'does not delete answer from db' do
        expect { process :destroy, method: :delete, params: { id: answer.id } }
            .to_not change(Answer, :count)
      end

      it 'redirects to related question page' do
        process :destroy, method: :delete, params: { id: answer.id }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

  end  
end