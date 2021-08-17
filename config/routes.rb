Rails.application.routes.draw do

  
  resources :users,only: [:index,:show,:new,:create]

  resource :session,only: [:new,:create,:destroy]

  resources :goals ,only: [:new,:create,:edit,:update,:show,:destroy] do 
    patch :complete ,on: :member
  end

  resources :goal_comments,only: [:create,:destroy]
  resources :user_comments,only: [:create,:destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
