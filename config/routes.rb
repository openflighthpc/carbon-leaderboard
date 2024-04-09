Rails.application.routes.draw do
  root "report#home"

  get "/leaderboard", to: "report#index"
  get "/leaderboard/:sort_column", to: "report#index"
  get "/user/:name", to: "report#show"
  get "/show-users", to: "users#show"
  post "/add-record", to: "report#add_record"
end
