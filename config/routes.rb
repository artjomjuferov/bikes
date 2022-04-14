Rails.application.routes.draw do
  namespace :api do
   resources :licences, only: [:create, :index]
 end
end
