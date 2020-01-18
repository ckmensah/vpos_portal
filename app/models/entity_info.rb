class EntityInfo < ApplicationRecord
  self.table_name="entity_info"
  self.primary_key = :assigned_code
  attr_accessor :action_type, :wallet_query#, :service_id, :secret_key, :client_key, :activity_type

  has_many :entity_divisions, class_name: 'EntityDivision', foreign_key: :entity_code
  has_many :entity_info_extras,  class_name: 'EntityInfoExtra', foreign_key: :entity_code
  has_many :entity_wallet_configs, class_name: 'EntityWalletConfig', foreign_key: :entity_code#, primary_key: :id
  belongs_to :entity_category, class_name: 'EntityCategory', foreign_key: :entity_cat_id, primary_key: :assigned_code


  validates :assigned_code, presence: true
  validates :entity_name, presence: {message: " cannot be empty."}
  validates :entity_cat_id, presence: {message: " cannot be empty."}
  validates :entity_alias, presence: {message: " cannot be empty."}
  # validates :service_id, presence: {message: " cannot be empty."}
  # validates :client_key, presence: {message: " cannot be empty."}
  # validates :secret_key, presence: {message: " cannot be empty."}
  # validates :activity_type, presence: {message: " cannot be empty."}
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


  def self.validate_wallet_config(wallet_params, assigned_code, wallet_state, action_type)
    wallet_validity = false
    key_number = 0
    logger.info "Wallet Parameter Class #{wallet_params.class}"
    if wallet_params != nil && wallet_params.class == ActionController::Parameters && wallet_state.present? && wallet_state == "yes"
      logger.info "test 1"
      logger.info "Wallet Parameter Class #{wallet_params.class}"
      wallet_params.each do |key, value|
        if value["service_id"].present? || value["secret_key"].present? || value["client_key"].present?
          logger.info "test 2"
          @service_id = EntityWalletConfig.where(service_id: value["service_id"], active_status: true, del_status: false).order(created_at: :desc).first
          @secret_key = EntityWalletConfig.where(secret_key: value["secret_key"], active_status: true, del_status: false).order(created_at: :desc).first
          @client_key = EntityWalletConfig.where(client_key: value["client_key"], active_status: true, del_status: false).order(created_at: :desc).first
          for_wallet_config = EntityWalletConfig.new(entity_code: assigned_code, activity_type_code: value["activity_type_code"],
                                                     service_id: value["service_id"], secret_key: value["secret_key"],
                                                     client_key: value["client_key"], active_status: true, del_status: false)
          logger.info "object is #{for_wallet_config.inspect}"
          if for_wallet_config.valid?
            if action_type == "for_update"
              wallet_validity = true
            else
              if @service_id || @secret_key || @client_key
                logger.info "test 6"
                wallet_validity = false
                key_number = key
                break
              else
                wallet_validity = true
              end
            end
          else
            logger.info "test 3"
            wallet_validity = false
            key_number = key
            break
          end
        else
          logger.info "test 4"
          # wallet_validity = true
        end
      end
    else
      logger.info "test 5"
      if wallet_state == "no" || wallet_params == nil
        wallet_validity = true
      end
    end

    return wallet_validity, key_number
  end


  def self.save_wallet_config(wallet_params, assigned_code)
    wallet_params.each do |key, value|
      if value["service_id"].present? && value["secret_key"].present? && value["client_key"].present?
        for_wallet_config = EntityWalletConfig.new(entity_code: assigned_code, activity_type_code: value["activity_type_code"],
                                                   service_id: value["service_id"], secret_key: value["secret_key"],
                                                   client_key: value["client_key"], active_status: true, del_status: false)
        for_wallet_config.save(validate: false)
      end
    end
  end


  def self.update_wallet_config(wallet_params, assigned_code)
    wallet_params.each do |key, value|
      if value["service_id"].present? && value["secret_key"].present? && value["client_key"].present?
        existing_wallets = EntityWalletConfig.where(entity_code: assigned_code, activity_type_code: value["activity_type_code"]).order(created_at: :desc)
        active_existing_wallets = existing_wallets.where(active_status: true, del_status: false).first
        logger.info "Exisiting wallet is :: #{existing_wallets.inspect}"
        if existing_wallets.exists?
          if active_existing_wallets
            active_existing_wallets.service_id = value["service_id"]
            active_existing_wallets.secret_key = value["secret_key"]
            active_existing_wallets.client_key = value["client_key"]
            active_existing_wallets.save(validate: false)

          end
        else
          for_wallet_config = EntityWalletConfig.new(entity_code: assigned_code, activity_type_code: value["activity_type_code"],
                                                     service_id: value["service_id"], secret_key: value["secret_key"],
                                                     client_key: value["client_key"], active_status: true, del_status: false)
          for_wallet_config.save(validate: false)
        end

      end
    end
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
