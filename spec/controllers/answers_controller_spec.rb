require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

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
        expect { process :create, method: :post, params: { answer: attributes_for(:invalid_answer), question_id: question },
                         format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template with error messages' do
        process :create, method: :post, params: { answer: attributes_for(:invalid_answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
  
    context 'delete by author' do
      let!(:answer) { create(:answer, user: @user) }
  
      it 'deletes answer from db' do
        expect { process :destroy, method: :delete, params: { id: answer.id }, format: :js }
            .to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        process :destroy, method: :delete, params: { id: answer.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'delete by someone else' do
      before { answer }

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