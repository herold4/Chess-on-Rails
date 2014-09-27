Rails.application.routes.draw do
  root to: 'games#index'
  post 'move', to: 'game#move'
end
