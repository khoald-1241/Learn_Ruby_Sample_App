Rails.application.routes.draw do
  get '/init_Suisei' => 'dynamic_page#init_Suisei'
  get '/home' => 'home#home'
  root :to => "home#home"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
