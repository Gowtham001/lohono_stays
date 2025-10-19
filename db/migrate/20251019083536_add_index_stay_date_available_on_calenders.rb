class AddIndexStayDateAvailableOnCalenders < ActiveRecord::Migration[8.0]
  def change
    add_index :calenders, [:available, :stay_date]
  end
end
