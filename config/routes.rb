Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'
  get 'search', to: 'home#search'
  get 'find_suggestions', to: 'home#find_suggestions'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
