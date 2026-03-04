class Campaign < ApplicationRecord
  has_many :campaign_memberships, dependent: :destroy
  has_many :users, through: :campaign_memberships
  has_many :maps, dependent: :destroy
  has_many :terrain_types, dependent: :destroy

  validates :name, presence: true
  validates :invite_code, presence: true, uniqueness: true

  before_validation :generate_invite_code, on: :create
  after_create :seed_default_terrain_types

  private

  def generate_invite_code
    self.invite_code ||= SecureRandom.alphanumeric(8)
  end

  DEFAULT_TERRAIN_TYPES = [
    { name: "Plains",     color: "#C8D96F", icon: "\u{1F33E}" },
    { name: "Forest",     color: "#2D6A4F", icon: "\u{1F332}" },
    { name: "Mountain",   color: "#6B7280", icon: "\u26F0\uFE0F" },
    { name: "Hills",      color: "#92794A", icon: "\u{1F3D4}\uFE0F" },
    { name: "Desert",     color: "#D4A853", icon: "\u{1F3DC}\uFE0F" },
    { name: "Ocean",      color: "#1E6FA8", icon: "\u{1F30A}" },
    { name: "Swamp",      color: "#5C6B2E", icon: "\u{1F33F}" },
    { name: "Tundra",     color: "#CBD5E0", icon: "\u2744\uFE0F" },
    { name: "Settlement", color: "#B45309", icon: "\u{1F3D8}\uFE0F" }
  ].freeze

  def seed_default_terrain_types
    rows = DEFAULT_TERRAIN_TYPES.map do |tt|
      tt.merge(campaign_id: id, built_in: true, created_at: Time.current, updated_at: Time.current)
    end
    TerrainType.insert_all(rows)
  end
end
