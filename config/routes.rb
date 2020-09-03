Rails.application.routes.draw do
  post "/calls", to: "calls#create"
  post "/get_digits", to: "calls#get_digits"
end
