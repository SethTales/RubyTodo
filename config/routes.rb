Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/users/create", to: "users#user"
  post "/users/create", to: "users#create"
  get "/users/login", to: "users#login"
  post "/users/login", to: "users#authenticate"

  get "/todo", to: "todo#todo"
  get "/todo/:user_id", to: "todo#todo_list"
end
