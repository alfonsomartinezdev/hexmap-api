class PlayerNote < ApplicationRecord
  belongs_to :hex
  belongs_to :user

  validates :body, presence: true
  validates :user_id, uniqueness: { scope: :hex_id }
  validate :hex_must_be_accessible

  private

  def hex_must_be_accessible
    return unless hex

    unless hex.status.in?(%w[revealed explored])
      errors.add(:hex, "must be revealed or explored to add notes")
    end
  end
end
