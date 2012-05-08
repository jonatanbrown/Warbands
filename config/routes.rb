Warbands::Application.routes.draw do

  authenticated :user do

    root to: 'home#home'

    resources :teams do
      member do
        post 'roll_stats'
        get 'select'
      end
    end

    match 'battles/queue' => 'battles#queue', :as => "queue"
    match 'battles/leave_queue' => 'battles#leave_queue', :as => "leave_queue"
    match 'battles/battle' => 'battles#battle', :as => "battle"
    match 'battles/confirm_turn' => 'battles#confirm_turn', :as => "confirm_turn"
    match 'battles/waiting_for_turn' => 'battles#waiting_for_turn', :as => "waiting_for_turn"
    match 'battles/next_turn' => 'battles#next_turn', :as => "next_turn"
    match 'battles/won_battle' => 'battles#won_battle', :as => "won_battle"
    match 'battles/lost_battle' => 'battles#lost_battle', :as => "lost_battle"
    match 'characters/:id/update' => 'characters#update'

  end

  devise_for :user do
     get "/", :to => "devise/sessions#new"
     get "/logout", :to => "devise/sessions#destroy"
     get "/sign_up", :to => "devise/registrations#new"
  end

  root to: 'home#index'

end

