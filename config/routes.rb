Rails.application.routes.draw do
  devise_for :users
  
  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  
  resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update] do
    get 'followings', on: :member, to: 'relationships#followings', as: 'followings'
    get 'followers', on: :member, to: 'relationships#followers', as: 'followers'
    resource :relationships, only: [:create, :destroy]  
  end
end
