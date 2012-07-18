Warbands::Application.routes.draw do

  authenticated :user do

    root to: 'home#home'

    resources :teams do
      member do
        post 'roll_stats'
        get 'select'
      end
    end

    match 'home/smithy' => 'home#smithy', :as => "smithy"

    resources :rankings, :only => 'index'

    match 'battles/queue' => 'battles#queue', :as => "queue"
    match 'battles/leave_queue' => 'battles#leave_queue', :as => "leave_queue"
    match 'battles/battle' => 'battles#battle', :as => "battle"
    match 'battles/confirm_turn' => 'battles#confirm_turn', :as => "confirm_turn"
    match 'battles/waiting_for_turn' => 'battles#waiting_for_turn', :as => "waiting_for_turn"
    match 'battles/next_turn' => 'battles#next_turn', :as => "next_turn"
    match 'battles/battle_finished' => 'battles#battle_finished', :as => "battle_finished"

    match 'characters/:id/update' => 'characters#update'

    match 'teams/:id/set_formation/:formation_num' => 'teams#set_formation'
    match 'teams/:id/set_character_positions/' => 'teams#set_character_positions'
    match 'teams/:id/in_battle/' => 'teams#in_battle'
    match 'teams/:id/formation/' => 'teams#formation'
    match 'teams/:id/purchase_item/:item' => 'teams#purchase_item'

    match 'battle_syncs/refresh_waiting_status' => 'battle_syncs#refresh_waiting_status'
    match 'battle_syncs/seconds_left' => 'battle_syncs#seconds_left'

  end

  devise_for :user do
     get "/", :to => "devise/sessions#new"
     get "/logout", :to => "devise/sessions#destroy"
     get "/sign_up", :to => "devise/registrations#new"
  end

  root to: 'home#index'

end

