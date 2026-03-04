class CreateTerrainTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :terrain_types do |t|
      t.references :campaign, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.string :color, null: false
      t.string :icon, null: false
      t.boolean :built_in, null: false, default: false

      t.timestamps
    end

    add_index :terrain_types, [ :campaign_id, :name ], unique: true
  end
end
