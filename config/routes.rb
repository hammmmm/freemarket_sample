Rails.application.routes.draw do
  devise_for :users,
     controllers: { registrations: 'users/registrations',
                    sessions: 'users/sessions' }
  resources :items
  resources :category, only:[:index,:show]
  root 'items#new'

end

