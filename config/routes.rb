Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  resources :jobs do
    resources :resumes

    put :favorite, on: :member
    member do
     post :add
     post :remove
   end

  end




  namespace :admin do
      resources :jobs do
        member do
          post :publish
          post :hide
        end

        resources :resumes
      end
    end


    resources :favorites


  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
