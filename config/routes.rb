Rails.application.routes.draw do

  get "/500", to: "errors#internal_error"

  namespace :api do # TODO: consider using condition ->(req) { req.format.in? %i[json xml] }
    namespace :v1 do
      post "transactions", to: "transactions#create"#, as: nil
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
