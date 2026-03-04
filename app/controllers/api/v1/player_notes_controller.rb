module Api
  module V1
    class PlayerNotesController < CampaignScopedController
      before_action :set_hex

      def create
        note = @hex.player_notes.find_or_initialize_by(user: current_user)
        note.body = params[:body]

        if note.save
          render json: note_json(note), status: note.previously_new_record? ? :created : :ok
        else
          render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        note = @hex.player_notes.find(params[:id])

        unless note.user_id == current_user.id
          return render json: { error: "Forbidden" }, status: :forbidden
        end

        if note.update(body: params[:body])
          render json: note_json(note)
        else
          render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_hex
        map = @campaign.maps.find(params[:map_id])
        @hex = map.hexes.find(params[:hex_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Not found" }, status: :not_found
      end

      def note_json(note)
        {
          id: note.id,
          body: note.body,
          author_name: note.user.name,
          updated_at: note.updated_at
        }
      end
    end
  end
end
