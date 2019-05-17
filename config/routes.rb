Rails.application.routes.draw do
  devise_for :users, path: "user", controllers:{
      omniauth_callbacks: "users/omniauth_callbacks"
  }
  devise_scope :users do
    delete 'sign_out', :to => 'devise/sessions#destroy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
end
