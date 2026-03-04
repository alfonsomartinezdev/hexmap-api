module Api
  module V1
    class MapsController < CampaignScopedController
      before_action :require_gm!, only: [ :create, :update, :destroy ]
      before_action :set_map, only: [ :show, :update, :destroy ]

      def index
        maps = @campaign.maps
        maps = maps.where(published: true) unless @membership.role == "gm"
        render json: maps.map { |m| map_json(m) }
      end

      def show
        unless @membership.role == "gm" || @map.published?
          return render json: { error: "Not found" }, status: :not_found
        end

        render json: map_json(@map)
      end

      def create
        map = @campaign.maps.new(map_params)

        if map.save
          render json: map_json(map), status: :created
        else
          render json: { errors: map.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @map.update(update_params)
          render json: map_json(@map)
        else
          render json: { errors: @map.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @map.destroy!
        head :no_content
      end

      private

      def set_map
        @map = @campaign.maps.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Not found" }, status: :not_found
      end

      def map_params
        params.permit(:name, :grid_cols, :grid_rows)
      end

      def update_params
        params.permit(:name, :published)
      end

      def map_json(map)
        {
          id: map.id,
          name: map.name,
          grid_cols: map.grid_cols,
          grid_rows: map.grid_rows,
          published: map.published,
          created_at: map.created_at,
          updated_at: map.updated_at
        }
      end
    end
  end
end
