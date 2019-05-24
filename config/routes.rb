Rails.application.routes.draw do
  devise_for :admins, path: "admin", :controllers => {
      :sessions => "admin/sessions"
  }
  devise_for :users, path: "user", controllers:{
      omniauth_callbacks: "users/omniauth_callbacks"
  }
  devise_scope :users do
    delete 'sign_out', :to => 'devise/sessions#destroy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'restaurants#index'

  resources :restaurants, except: [:index] do
    collection do
      post :follow
      get :load_new
      get :load_follow
    end
  end


  namespace :admin do
    root 'admin#index'
    resources :restaurants
  end
end
