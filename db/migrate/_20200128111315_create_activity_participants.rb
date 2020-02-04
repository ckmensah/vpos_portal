class CreateActivityParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_participants do |t|
      t.string :assigned_code
      t.string :division_code
      t.string :participant_name
      t.string :participant_alias
      t.text :image_data
      t.string :image_path
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
    end
  end
end
