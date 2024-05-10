Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  root "home#index"

  post "/add-record",                    to: "report#add_record"

  get "/device/:device",                 to: "device#show"
  post "/add-tag/:device",               to: "device#add_tag"
  post "/delete-tag/:device",            to: "device#delete_tag"

  get "/group/:group_id",                to: "group#show"
  get "/leaderboard/grouped",            to: "group#index"
  get "/leaderboard/grouped-data/:unit", to: "group#raw_data"

  get "/user/:username",                 to: "user#profile"

  get "/data-entry",                     to: "data_entry#index"
  get "/download-carbon",                to: "data_entry#download_carbon"
  post "/data-entry/upload",             to: "data_entry#upload"

  get "/faq",                            to: "faq#index"
end
