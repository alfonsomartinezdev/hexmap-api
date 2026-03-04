class Map < ApplicationRecord
  belongs_to :campaign
  has_many :hexes, dependent: :delete_all

  validates :name, presence: true, uniqueness: { scope: :campaign_id }
  validates :grid_cols, presence: true, numericality: { only_integer: true, in: 1..30 }
  validates :grid_rows, presence: true, numericality: { only_integer: true, in: 1..30 }

  after_create :seed_hexes

  private

  def seed_hexes
    now = Time.current
    rows = []
    grid_rows.times do |r|
      grid_cols.times do |q|
        rows << {
          map_id: id,
          q: q,
          r: r,
          active: false,
          status: "unrevealed",
          created_at: now,
          updated_at: now
        }
      end
    end
    Hex.insert_all(rows)
  end
end
