Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  root "home#index"

  get "/leaderboard", to: "report#index"
  get "/leaderboard/:sort_column", to: "report#index"
  get "/user/:name", to: "report#show"
  get "/show-devices", to: "device#show"
  post "/add-record", to: "report#add_record"
end
