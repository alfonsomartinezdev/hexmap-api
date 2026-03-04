module Api
  module V1
    class TerrainTypesController < CampaignScopedController
      before_action :require_gm!, only: [ :create, :update, :destroy ]

      def index
        terrain_types = @campaign.terrain_types
        render json: terrain_types.map { |tt| terrain_type_json(tt) }
      end

      def create
        tt = @campaign.terrain_types.new(terrain_type_params)

        if tt.save
          render json: terrain_type_json(tt), status: :created
        else
          render json: { errors: tt.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        tt = @campaign.terrain_types.find(params[:id])

        if tt.update(terrain_type_params)
          render json: terrain_type_json(tt)
        else
          render json: { errors: tt.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        tt = @campaign.terrain_types.find(params[:id])

        if tt.built_in?
          render json: { error: "Cannot delete built-in terrain types" }, status: :forbidden
        else
          tt.destroy!
          head :no_content
        end
      end

      private

      def terrain_type_params
        params.permit(:name, :color, :icon)
      end

      def terrain_type_json(tt)
        {
          id: tt.id,
          name: tt.name,
          color: tt.color,
          icon: tt.icon,
          built_in: tt.built_in,
          campaign_id: tt.campaign_id
        }
      end
    end
  end
end
