class CreateActivityFixtures < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_fixtures do |t|
      t.string :division_code
      t.string :activity_participant_a
      t.string :activity_participant_b

      t.timestamps
    end
  end
end
