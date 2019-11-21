class EntityDivision < ApplicationRecord
  self.table_name="entity_division"
  self.primary_key = :assigned_code
  attr_accessor :region_name, :city_town_name,:action_type
  # validates_uniqueness_of :region_name
  has_many :entity_division_exts, class_name: 'EntityDivisionExt', foreign_key: :entity_div_code
  has_many :activity_divs, class_name: 'ActivityDiv', foreign_key: :division_code
  has_many :entity_wallet_configs, class_name: 'EntityWalletConfig', foreign_key: :division_code
  # has_many :assigned_service_code, class_name: 'AssignedServiceCode', foreign_key: :entity_div_code
  belongs_to :activity_type, class_name: 'ActivityType', foreign_key: :activity_type_code
  belongs_to :entity_info, class_name: 'EntityInfo', foreign_key: :entity_code
  belongs_to :suburb_master, class_name: 'SuburbMaster', foreign_key: :suburb_id

  # validates :assigned_code, presence: true
  validates :entity_code, presence: {message: " cannot be empty."}
  validates :division_name, presence: {message: " cannot be empty."}

  validates :region_name, presence: {message: " cannot be empty."}

  validates :city_town_name, presence: {message: " cannot be empty."}
  validates :suburb_id, presence: {message: " cannot be empty."}
  validates :activity_type_code, presence: {message: " cannot be empty."}
  validates :service_label, presence: {message: " cannot be empty."}
  accepts_nested_attributes_for :entity_wallet_configs#, :activity_divs

  def self.gen_entity_div_code
    sql = "select nextval('entity_division_codes')"
    val = ActiveRecord::Base.connection.execute(sql)
    val = val.values[0][0]
    logger.info "For Entity division ID, #{val}"
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