class CreateCampaignMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.string :role, null: false

      t.timestamps
    end

    add_index :campaign_memberships, [ :user_id, :campaign_id ], unique: true
  end
end
