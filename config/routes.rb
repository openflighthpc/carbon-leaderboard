Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  root "home#index"

  get "/leaderboard", to: "report#index"
  get "/leaderboard/raw-data", to: "report#raw_data"
  get "/user/:name", to: "report#show"
  get "/show-devices", to: "device#show"
  post "/add-record", to: "report#add_record"
  post "/add-tag/:report", to: "report#add_tag"
  post "/delete-tag/:report", to: "report#delete_tag"
end
