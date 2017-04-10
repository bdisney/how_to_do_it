Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users

  root 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: [:new, :create, :destroy], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, only: [:create, :edit, :update, :destroy],
              concerns: [:votable, :commentable], shallow: true do
      patch :accept, on: :member
    end
  end

  mount ActionCable.server => '/cable'
end

