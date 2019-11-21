class EntityInfo < ApplicationRecord
  self.table_name="entity_info"
  self.primary_key = :assigned_code
  attr_accessor :action_type

  has_many :entity_divisions, class_name: 'EntityDivision', foreign_key: :entity_code
  has_many :entity_info_extras,  class_name: 'EntityInfoExtra', foreign_key: :entity_code
  belongs_to :entity_category, class_name: 'EntityCategory', foreign_key: :entity_cat_id, primary_key: :assigned_code

  validates :assigned_code, presence: true
  validates :entity_name, presence: {message: "Entity name cannot be empty."}
  validates :entity_cat_id, presence: {message: "Entity category cannot be empty."}
  validates :entity_alias, presence: {message: "Entity Alias cannot be empty."}
  accepts_nested_attributes_for :entity_info_extras

  def entity_info_name_join
    "#{entity_name} (#{entity_alias})"
  end

  def self.gen_entity_info_code
    sql = "select nextval('entity_info_codes')"
    val = ActiveRecord::Base.connection.execute(sql)
    val = val.values[0][0]
    logger.info "For Entity info ID, #{val}"
    val
    "#{val}"
    # code = "%07d" % val
    # "ST#{code}"
  end

  def self.update_last_but_one(table,id_field,id)
    sql = "UPDATE #{table} SET active_status = false, del_status = true WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND active_status = true AND del_status = false order by id asc LIMIT 1)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end

  def self.disable_by_update_onef(table,id_field,id)
    sql = "UPDATE #{table} SET active_status = false WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND active_status = true AND del_status = false)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end

  def self.enable_by_update_onet(table,id_field,id)
    sql = "UPDATE #{table} SET active_status = true WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND active_status = false AND del_status = false)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end

end
