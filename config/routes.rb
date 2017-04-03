Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users

  root 'questions#index'
  
    resources :questions, except: [:edit, :update] do
      resources :answers, only: [:create, :edit, :update, :destroy], shallow: true
    end
end

