class EntityInfo < ApplicationRecord
  self.table_name="entity_info"
  self.primary_key = :assigned_code
  attr_accessor :action_type, :wallet_query, :wallet_file #, :service_id, :secret_key, :client_key, :activity_type

  has_many :entity_divisions, class_name: 'EntityDivision', foreign_key: :entity_code
  has_many :entity_info_extras,  class_name: 'EntityInfoExtra', foreign_key: :entity_code
  has_many :entity_wallet_configs, class_name: 'EntityWalletConfig', foreign_key: :entity_code#, primary_key: :id
  has_many :users, class_name: 'User', foreign_key: :entity_code

  belongs_to :entity_category, class_name: 'EntityCategory', foreign_key: :entity_cat_id, primary_key: :assigned_code


  #validates :assigned_code, presence: true
  validates :entity_name, presence: {message: " cannot be empty."}
  validates :entity_cat_id, presence: {message: " cannot be empty."}
  validates :entity_alias, presence: {message: " cannot be empty."}
  # validates :service_id, presence: {message: " cannot be empty."}
  # validates :client_key, presence: {message: " cannot be empty."}
  # validates :secret_key, presence: {message: " cannot be empty."}
  # validates :activity_type, presence: {message: " cannot be empty."}
  accepts_nested_attributes_for :entity_info_extras



  def self.gather_all_assigned_code(all_merchants)
    assigned_code_arr = []
    all_merchants.each_with_index do |merchant, index|
      logger.info "#{index + 1}. Merchant :: #{merchant.inspect} and Assigned Code :: #{merchant.assigned_code.inspect}"
      unless assigned_code_arr.include?("#{merchant.assigned_code}")
        assigned_code_arr << "#{merchant.assigned_code}"
      end
    end
    logger.info "Assigned Code Array :: #{assigned_code_arr.inspect}"
    assigned_code_arr
  end



  def self.same_created_at(all_merchants)
    assigned_code_arr = gather_all_assigned_code(all_merchants)
    if assigned_code_arr.any?
      assigned_code_arr.each_with_index do |assigned_code, index|
        logger.info "#{index + 1}. Assigned Code = #{assigned_code.inspect}"
        merchant_objs = EntityInfo.where(assigned_code: assigned_code).order(created_at: :desc)
        first_insertion = merchant_objs.last
        if first_insertion
          logger.info "New Date :: #{first_insertion.created_at.strftime('%Y-%m-%d %H:%M:%S.%N')}"

          sql = "UPDATE entity_info SET created_at = '#{first_insertion.created_at.strftime('%Y-%m-%d %H:%M:%S.%N')}' WHERE id IN (SELECT id FROM entity_info WHERE assigned_code = '#{assigned_code}')"
          val = ActiveRecord::Base.connection.execute(sql)

          #merchant_objs.each_with_index do |merchant_obj, index1|
          #  logger.info "#{index1 + 1}. Original Date: #{merchant_obj.created_at} and New Date: #{first_insertion.created_at}"
          #  merchant_obj.created_at = first_insertion.created_at
          #  merchant_obj.save(validate: false)
          #end
        end

      end
    end

  end


  #def self.updated_at_correction
  #  ids = [2,5,6,12,16,17,18,24,25,26,19,20,21,22,23,27,29,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63]
  #
  #  dates = ['2019-10-24 11:59:51.931662','2019-10-24 18:31:10.316688','2019-11-25 11:17:47.307567','2019-12-19 11:55:12.035084','2020-02-03 18:12:16.029442','2020-02-06 15:39:44.300525','2020-02-10 13:45:51.727656','2020-02-11 08:43:55.805739','2020-02-11 11:08:38.347783','2020-02-11 11:09:40.4945','2020-02-11 12:08:23.197416','2020-02-11 12:16:34.64838','2020-02-11 12:33:39.381835','2020-02-11 13:24:04.579285','2020-02-11 13:28:08.419578','2020-02-11 16:50:06.43166','2020-02-18 14:16:08.111329','2020-02-19 18:12:26.051121','2020-02-19 18:18:59.878925','2020-02-19 18:50:12.19215','2020-02-20 13:56:42.938624','2020-02-20 13:56:56.358533','2020-02-20 15:46:27.070916','2020-02-20 16:05:21.203678','2020-02-20 16:11:14.957836','2020-02-20 16:14:12.860578','2020-02-24 15:54:57.424286','2020-03-04 10:52:25.49024','2020-03-13 12:03:52.664996','2020-03-13 12:42:56.714299','2020-03-30 13:00:56.21292','2020-04-06 17:10:28.12443','2020-04-19 20:21:45.806232','2020-04-22 14:41:46.930235','2020-04-23 11:06:42.104835','2020-04-23 12:04:47.409433','2020-04-30 15:43:39.663502','2020-05-13 11:21:42.61819','2020-05-14 13:22:27.673617','2020-05-14 13:23:04.384094','2020-05-14 13:23:12.087471','2020-05-15 16:00:54.517481','2020-05-15 16:01:02.098637','2020-05-15 16:01:10.209785','2020-05-15 16:38:19.061427','2020-05-15 16:48:13.519191','2020-05-15 16:57:52.725387','2020-05-16 11:35:42.894998','2020-05-18 11:35:57.022456','2020-05-19 22:04:02.225186']
  #  logger.info "ID SIZE :: #{ids.size.inspect}"
  #  logger.info "DATE SIZE :: #{dates.size.inspect}"
  #  if ids.size == dates.size
  #    ids.each_with_index do |the_id, index|
  #      logger.info "#{the_id} | #{dates[index]}"
  #      sql = "UPDATE entity_info SET updated_at = '#{dates[index]}' WHERE id = #{the_id}"
  #      val = ActiveRecord::Base.connection.execute(sql)
  #    end
  #  end
  #
  #end


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


  #def self.format_amount(amount)
  #  amt = (amount.round(2) * 100).to_i.to_s
  #  (amount.present? && amount > 0 && amt.length <= 12) ? "%012d" % amt : "000000000000"
  #end



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
              #if @service_id || @secret_key || @client_key
              #  logger.info "test 6"
              #  wallet_validity = false
              #  key_number = key
              #  break
              #else
              #  wallet_validity = true
              #end
              wallet_validity = true
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


  def self.save_wallet_config(wallet_params, assigned_code, current_user)
    wallet_params.each do |key, value|
      if value["service_id"].present? && value["secret_key"].present? && value["client_key"].present?
        for_wallet_config = EntityWalletConfig.new(entity_code: assigned_code, activity_type_code: value["activity_type_code"],
                                                   service_id: value["service_id"], secret_key: value["secret_key"], user_id: current_user.id,
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
