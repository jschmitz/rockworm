Rails.application.routes.draw do
  get "welcome/index"
  root "welcome#index"

  post "/calls", to: "calls#create"
  post "/get_digits", to: "calls#get_digits"
  get "/workout_logs", to: "workout_logs#index"
  post "/record_utterance", to: "calls#record_utterance"
end
