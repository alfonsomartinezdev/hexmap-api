class User < ApplicationRecord
  has_secure_password

  has_many :campaign_memberships, dependent: :destroy
  has_many :campaigns, through: :campaign_memberships
  has_many :player_notes, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
