class CampaignMembership < ApplicationRecord
  belongs_to :user
  belongs_to :campaign

  ROLES = %w[gm player].freeze

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :campaign_id }
end
