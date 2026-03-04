class CreateHexes < ActiveRecord::Migration[8.0]
  def change
    create_table :hexes do |t|
      t.references :map, null: false, foreign_key: { on_delete: :cascade }
      t.integer :q, null: false
      t.integer :r, null: false
      t.boolean :active, null: false, default: false
      t.string :status, null: false, default: "unrevealed"
      t.references :terrain_type, null: true, foreign_key: { on_delete: :nullify }
      t.string :name
      t.text :description

      t.timestamps
    end

    add_index :hexes, [ :map_id, :q, :r ], unique: true
  end
end
