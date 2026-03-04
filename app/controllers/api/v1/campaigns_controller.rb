module Api
  module V1
    class CampaignsController < BaseController
      def index
        memberships = current_user.campaign_memberships.includes(:campaign)
        campaigns = memberships.map do |m|
          campaign_json(m.campaign, m.role)
        end
        render json: campaigns
      end

      def show
        campaign = Campaign.find(params[:id])
        membership = current_user.campaign_memberships.find_by(campaign_id: campaign.id)
        return render json: { error: "Forbidden" }, status: :forbidden unless membership

        render json: campaign_json(campaign, membership.role)
      end

      def create
        campaign = Campaign.new(name: params[:name])

        if campaign.save
          campaign.campaign_memberships.create!(user: current_user, role: "gm")
          render json: campaign_json(campaign, "gm"), status: :created
        else
          render json: { errors: campaign.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def join
        campaign = Campaign.find_by(invite_code: params[:invite_code])
        return render json: { error: "Invalid invite code" }, status: :not_found unless campaign

        existing = current_user.campaign_memberships.find_by(campaign_id: campaign.id)
        return render json: { error: "Already a member" }, status: :conflict if existing

        membership = campaign.campaign_memberships.create!(user: current_user, role: "player")
        render json: campaign_json(campaign, membership.role), status: :created
      end

      private

      def campaign_json(campaign, role)
        json = {
          id: campaign.id,
          name: campaign.name,
          role: role,
          created_at: campaign.created_at
        }
        json[:invite_code] = campaign.invite_code if role == "gm"
        json
      end
    end
  end
end
