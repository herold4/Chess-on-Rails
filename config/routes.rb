Rails.application.routes.draw do
  root to: 'games#index'
  post 'move', to: 'games#move'
  get 'move', to: 'games#index'
  get 'new', to: 'games#newgame'
end
