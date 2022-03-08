Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    get "static_pages/help"
    get "static_pages/contact"
    root to: "static_pages#home"

    get "/signup", to: "users#new"
    resources :users
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
