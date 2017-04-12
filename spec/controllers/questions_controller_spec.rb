require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_should_behave_like 'voted'

  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'assigns @questions' do
      expect(assigns(:questions)).to eq(questions)
    end

    it 'renders the index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question) }

    before { get :show, params: { id: question.id } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders the show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders the new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'save question to db' do
        expect { process :create, method: :post, params: { question: attributes_for(:question) } }
            .to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        process :create, method: :post, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question to db' do
        expect { process :create, method: :post, params: { question: attributes_for(:invalid_question) } }
            .to_not change(Question, :count)
      end

      it 'render new view' do
        process :create, method: :post, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user

    context 'edit by author' do
      let!(:users_question) { create(:question, user: @user) }
      before { get :edit, xhr: true, params: { id: users_question.id }, format: :js }

      it 'assigns requested question to @question' do
        expect(assigns(:question)).to eq(users_question)
      end

      it 'renders edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'edit by someone else' do
      before { get :edit, xhr: true, params: { id: question.id }, format: :js }

      it 'responds with status 403 (forbidden)' do
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:users_question) { create(:question, user: @user) }

    context 'update by author with valid attributes' do
      before { process :update, method: :patch,
                       params: { id: users_question.id, question: { title: 'new question title', body: 'new question body' } },
                       format: :js }

      it 'assigns requested question to @question' do
        expect(assigns(:question)).to eq(users_question)
      end

      it 'saves new question to db' do
        users_question.reload
        expect(users_question.title).to eq 'new question title'
        expect(users_question.body).to eq 'new question body'
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'update by author with invalid attributes' do
      before { process :update, method: :patch,
                       params: { id: users_question.id, question: { title: '', body: '' } },
                       format: :js }

      it 'does not save question to db' do
        users_question.reload
        expect(users_question.title).to match /^question_title_\d+$/
        expect(users_question.body).to match /^question_body_\d+$/
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'update by someone else' do
      it 'responds with status 403 (forbidden)' do
        process :update, method: :patch, params: { id: question.id, question: attributes_for(:question) }, format: :js
        expect(response.status).to eq(403)
      end
    end

  end


  describe 'DELETE #destroy' do
    sign_in_user
    
    context 'delete by author' do
      let!(:users_question) { create(:question, user: @user) }
    
      it 'deletes question from db' do
        expect { process :destroy, method: :delete, params: { id: users_question.id } }
            .to change(Question, :count).by(-1)
      end
  
      it 'redirects to index' do
        process :destroy, method: :delete, params: { id: users_question.id }
        expect(response).to redirect_to questions_path
      end
    end

    context 'delete by someone else' do
      before { question }

      it 'does not delete question from db' do
        expect { process :destroy, method: :delete, params: { id: question.id } }
            .to_not change(Question, :count)
      end

      it 'redirects to index' do
        process :destroy, method: :delete, params: { id: question.id }
        expect(response).to redirect_to root_path
      end
    end
  end
end