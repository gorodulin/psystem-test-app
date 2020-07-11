Rails.application.routes.draw do

  resources :merchants, except: [:create, :new, :show], format: false
  resources :transactions, only: [:index], format: false

  get "/500", to: "errors#internal_error"

  namespace :api do # TODO: consider using condition ->(req) { req.format.in? %i[json xml] }
    namespace :v1 do
      post "transactions", to: "transactions#create", format: false
    end
  end

end
