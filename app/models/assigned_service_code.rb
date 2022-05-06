class AssignedServiceCode < ApplicationRecord
  self.table_name="assigned_service_code"
  self.primary_key = :id
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code

  validates :entity_div_code, presence: {message: " cannot be empty."}
  validates :service_code, presence: {message: " cannot be empty."}, format: { with: /\A\d+\z/, message: "must be numbers only." }, length: {minimum: 1, maximum: 6}


  def self.update_last_but_one(table, id_field, id)
    sql = "UPDATE #{table} SET active_status = false, del_status = true WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND active_status = true AND del_status = false order by id asc LIMIT 1)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end
  
end
