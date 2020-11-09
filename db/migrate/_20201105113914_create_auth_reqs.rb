class CreateAuthReqs < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_reqs do |t|

      t.timestamps
    end
  end
end
