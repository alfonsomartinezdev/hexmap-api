class CreateMaps < ActiveRecord::Migration[8.0]
  def change
    create_table :maps do |t|
      t.references :campaign, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.integer :grid_cols, null: false
      t.integer :grid_rows, null: false
      t.boolean :published, null: false, default: false

      t.timestamps
    end

    add_index :maps, [ :campaign_id, :name ], unique: true
  end
end
