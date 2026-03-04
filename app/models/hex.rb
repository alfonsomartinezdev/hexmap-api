class Hex < ApplicationRecord
  belongs_to :map
  belongs_to :terrain_type, optional: true
  has_many :player_notes, dependent: :delete_all

  STATUSES = %w[unrevealed revealed explored].freeze

  validates :q, presence: true
  validates :r, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  scope :active, -> { where(active: true) }
end
