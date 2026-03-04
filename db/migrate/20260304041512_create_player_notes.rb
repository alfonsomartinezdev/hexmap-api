class CreatePlayerNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :player_notes do |t|
      t.references :hex, null: false, foreign_key: { on_delete: :cascade }
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false

      t.timestamps
    end

    add_index :player_notes, [ :hex_id, :user_id ], unique: true
  end
end
