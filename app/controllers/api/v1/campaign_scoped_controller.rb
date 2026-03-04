module Api
  module V1
    class CampaignScopedController < BaseController
      before_action :set_campaign
      before_action :set_membership

      private

      def set_campaign
        @campaign = Campaign.find(params[:campaign_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Campaign not found" }, status: :not_found
      end

      def set_membership
        @membership = current_user.campaign_memberships.find_by(campaign_id: @campaign.id)
        render json: { error: "Forbidden" }, status: :forbidden unless @membership
      end

      def require_gm!
        render json: { error: "Forbidden" }, status: :forbidden unless @membership&.role == "gm"
      end
    end
  end
end
