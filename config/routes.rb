Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  root "home#index"

  get "/leaderboard",              to: "report#index"
  post "/add-record",              to: "report#add_record"

  get "/show-devices",             to: "device#show"
  get "/leaderboard/raw-data",     to: "device#raw_data"
  post "/add-tag/:device",         to: "device#add_tag"
  post "/delete-tag/:device",      to: "device#delete_tag"

  get "/user/:username",           to: "user#profile"
end
