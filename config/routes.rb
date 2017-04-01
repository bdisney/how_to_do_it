Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#index'
  
    resources :questions, except: [:edit, :update, :destroy] do
      resources :answers, only: [:new, :create]
    end
end

