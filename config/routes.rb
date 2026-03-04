Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # Authentication (unauthenticated)
      post   "auth/register", to: "auth#register"
      post   "auth/login",    to: "auth#login"
      delete "auth/logout",   to: "auth#logout"

      # Campaigns
      resources :campaigns, only: [ :index, :show, :create ] do
        collection do
          post :join
        end

        # Maps (campaign-scoped)
        resources :maps, only: [ :index, :show, :create, :update, :destroy ] do
          # Hexes (map-scoped)
          resources :hexes, only: [ :index, :update ] do
            # Player Notes (hex-scoped)
            resources :player_notes, only: [ :create, :update ]
          end
        end

        # Terrain Types (campaign-scoped)
        resources :terrain_types, only: [ :index, :create, :update, :destroy ]
      end
    end
  end
end
