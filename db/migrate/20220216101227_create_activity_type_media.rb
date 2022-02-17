class CreateActivityTypeMedia < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_type_media do |t|
      t.string :activity_type_code
      t.string :media_path
      t.string :media_data
      t.string :media_type
      t.text :comment
      t.boolean :active_status
      t.boolean :del_status
      t.integer :user_id

      t.timestamps
      t.index ["activity_type_code"], name:"activity_type_media_activity_type_code_idx"
      t.index ["media_path"], name:"activity_type_media_media_path_idx"
      t.index ["media_data"], name:"activity_type_media_media_data_idx"
      t.index ["media_type"], name:"activity_type_media_media_type_idx"
      t.index ["comment"], name:"activity_type_media_comment_idx"
      t.index ["active_status"], name:"activity_type_media_active_status_idx"
      t.index ["del_status"], name:"activity_type_media_del_status_idx"
      t.index ["user_id"], name:"activity_type_media_user_id_idx"
      t.index ["created_at"], name:"activity_type_media_created_at_idx"
      t.index ["updated_at"], name:"activity_type_media_updated_at_idx"
    end
  end
end
