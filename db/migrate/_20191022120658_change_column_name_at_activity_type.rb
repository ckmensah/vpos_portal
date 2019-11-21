class ChangeColumnNameAtActivityType < ActiveRecord::Migration[5.2]
  def change
    rename_column :activity_type, :activity_type_desc, :activity_type_desc
  end
end
