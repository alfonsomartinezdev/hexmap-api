class TerrainType < ApplicationRecord
  belongs_to :campaign
  has_many :hexes, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :campaign_id }
  validates :color, presence: true
  validates :icon, presence: true
end
