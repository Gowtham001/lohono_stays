class CreateVillas < ActiveRecord::Migration[8.0]
  def change
    create_table :villas do |t|
      t.string :name, null: false
      t.timestamp :deleted_at
      t.timestamps null: false
    end
  end
end
