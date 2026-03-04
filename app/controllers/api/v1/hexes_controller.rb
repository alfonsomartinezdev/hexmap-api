module Api
  module V1
    class HexesController < CampaignScopedController
      before_action :set_map
      before_action :require_gm!, only: [ :update ]

      def index
        hexes = @map.hexes.includes(:terrain_type, player_notes: :user)
        hexes = hexes.active unless @membership.role == "gm"

        render json: hexes.map { |h| hex_json(h) }
      end

      def update
        hex = @map.hexes.find(params[:id])

        if hex.update(hex_params)
          render json: hex_json(hex)
        else
          render json: { errors: hex.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_map
        @map = @campaign.maps.find(params[:map_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Not found" }, status: :not_found
      end

      def hex_params
        params.permit(:active, :status, :terrain_type_id, :name, :description)
      end

      def hex_json(hex)
        if @membership.role == "gm"
          gm_hex_json(hex)
        else
          player_hex_json(hex)
        end
      end

      def gm_hex_json(hex)
        {
          id: hex.id,
          q: hex.q,
          r: hex.r,
          active: hex.active,
          status: hex.status,
          terrain_type: hex.terrain_type ? terrain_type_json(hex.terrain_type) : nil,
          name: hex.name,
          description: hex.description,
          player_notes: hex.player_notes.map { |n| note_json(n) }
        }
      end

      def player_hex_json(hex)
        json = { id: hex.id, q: hex.q, r: hex.r, status: hex.status }

        if hex.status.in?(%w[revealed explored])
          json[:terrain_type] = hex.terrain_type ? terrain_type_json(hex.terrain_type) : nil
          json[:player_notes] = hex.player_notes.map { |n| note_json(n) }
        end

        if hex.status == "explored"
          json[:name] = hex.name
          json[:description] = hex.description
        end

        json
      end

      def terrain_type_json(tt)
        { id: tt.id, name: tt.name, color: tt.color, icon: tt.icon }
      end

      def note_json(note)
        { id: note.id, body: note.body, author_name: note.user.name, updated_at: note.updated_at }
      end
    end
  end
end
