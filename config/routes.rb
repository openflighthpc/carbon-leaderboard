Rails.application.routes.draw do
  root "report#home"

  get "/leaderboard", to: "report#index"
  get "/leaderboard/:name", to: "report#show"
  get "/show-users", to: "users#show"
  post "/add-record", to: "report#add_record"
end
