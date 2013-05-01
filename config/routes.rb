Prisoner::Application.routes.draw do
  resources :users
  match 'random_user', to: 'users#random', as: 'random_user'
  match 'leaderboard', to: 'users#leaders', as: 'leaderboard'

  match 'home', to: 'home#index', as: 'home'

  resources :stages

  resources "games" do
    put "respond"
    get "results"
  end

  match 'game_responses', to: 'games#waiting_responses', as: 'game_responses'
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  root :to => 'stages#index'
end
