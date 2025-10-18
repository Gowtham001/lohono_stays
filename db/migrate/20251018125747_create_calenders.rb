class CreateCalenders < ActiveRecord::Migration[8.0]
  def change
    create_table :calenders do |t|
      t.references :villa, null: false
      t.date :stay_date, null: false
      t.boolean :available, null: false, default: true
      t.decimal :price, precision: 10, scale: 2
      t.timestamp :deleted_at
      t.timestamps null: false
    end
  end
end
