class AssignedFee < ApplicationRecord
  #self.table_name="assigned_fee"
  self.primary_key = :id
  #validates_uniqueness_of :entity_div_code #, :assigned_code

  #has_many :entity_divisions, class_name: 'EntityDivision', foreign_key: :activity_type_code
  belongs_to :entity_division, class_name: 'EntityDivision', foreign_key: :entity_div_code

  validates :entity_div_code, presence: {message: " cannot be empty."}
  validates :trans_type, presence: {message: " cannot be empty."}
  validates :fee, presence: {message: " cannot be empty."}
  validates :flat_percent, presence: {message: " cannot be empty."}
  #validates :cap, presence: {message: " cannot be empty."}
  #validates :limit_capped, presence: {message: " cannot be empty."}
  validates :charged_to, presence: {message: " cannot be empty."}


  def self.update_last_but_one1(table, id_field, id, charged_to)
    sql = "UPDATE #{table} SET active_status = false, del_status = true WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND charged_to = '#{charged_to}' AND active_status = true AND del_status = false order by id asc LIMIT 1)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end

  def self.update_last_but_one(table, id)
      sql = "UPDATE #{table} SET active_status = false, del_status = true WHERE id = #{id}"
      val = ActiveRecord::Base.connection.execute(sql)
  end

end
