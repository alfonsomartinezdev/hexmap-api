class CreateCampaigns < ActiveRecord::Migration[8.0]
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.string :invite_code, null: false

      t.timestamps
    end

    add_index :campaigns, :invite_code, unique: true
  end
end
