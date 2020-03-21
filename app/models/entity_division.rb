class EntityDivision < ApplicationRecord
  self.table_name = "entity_division"
  self.primary_key = :assigned_code
  attr_accessor :region_name, :city_town_name, :service_code, :action_type, :for_update, :div_lov_query, :activity_query,
                :sub_activity_query, :serv_id, :s_key, :c_key, :sport_type, :sport_category, :category_type, :for_fixture
  # validates_uniqueness_of :region_name
  has_many :entity_division_exts, class_name: 'EntityDivisionExt', foreign_key: :entity_div_code
  has_many :activity_divs, class_name: 'ActivityDiv', foreign_key: :division_code
  has_many :assigned_service_codes, class_name: 'AssignedServiceCode', foreign_key: :entity_div_code
  has_many :division_activity_lovs, class_name: 'DivisionActivityLov', foreign_key: :division_code
  has_many :activity_sub_div_class, class_name: 'ActivitySubDivClass', foreign_key: :entity_div_code
  has_many :payment_infos, class_name: 'PaymentInfo', foreign_key: :entity_div_code
  has_many :users, class_name: 'User', foreign_key: :division_code
  has_many :activity_participants, class_name: 'ActivityParticipant', foreign_key: :division_code
  has_many :activity_fixtures, class_name: 'ActivityFixture', foreign_key: :division_code
  has_many :activity_category_divs, class_name: 'ActivityCategoryDiv', foreign_key: :division_code
  has_many :activity_div_cats, class_name: 'ActivityDivCat', foreign_key: :division_code
  has_many :assigned_fees, class_name: 'AssignedFee', foreign_key: :entity_div_code
  has_many :entity_service_accounts, class_name: "EntityServiceAccount", foreign_key: :entity_div_code
  has_many :entity_service_account_trxns, class_name: "EntityServiceAccountTrxn", foreign_key: :entity_div_code
  has_many :entity_wallet_configs, class_name: "EntityWalletConfig", foreign_key: :division_code
  has_many :entity_admin_whitelists, class_name: "EntityAdminWhitelist", foreign_key: :entity_division_code
  has_many :entity_div_sub_activities, class_name: "EntityDivSubActivity", foreign_key: :entity_div_code


  # has_many :entity_wallet_configs, class_name: 'EntityWalletConfig', foreign_key: :division_code
  # has_many :assigned_service_code, class_name: 'AssignedServiceCode', foreign_key: :entity_div_code

  belongs_to :activity_type, class_name: 'ActivityType', foreign_key: :activity_type_code
  belongs_to :entity_info, class_name: 'EntityInfo', foreign_key: :entity_code
  belongs_to :suburb_master, class_name: 'SuburbMaster', foreign_key: :suburb_id

  # validates :assigned_code, presence: true
  validates :entity_code, presence: {message: " cannot be empty."}
  validates :division_name, presence: {message: " cannot be empty."}
  validates :division_alias, presence: {message: " cannot be empty."}
  validates :sms_sender_id, presence: {message: " cannot be empty."}, length: {minimum: 3, maximum: 9}

  validates :region_name, presence: {message: " cannot be empty."}

  validates :city_town_name, presence: {message: " cannot be empty."}
  validates :suburb_id, presence: {message: " cannot be empty."}
  validates :activity_type_code, presence: {message: " cannot be empty."}
  validates :service_label, presence: {message: " cannot be empty."}
  validates :service_code, presence: {message: " cannot be empty."}, format: {with: /\A\d+\z/, message: "must be numbers only."}
  #validate :service_code_validation, :if => :for_update
  #validate :create_serv_code_validation, :unless => :for_update
  validate :secret_key_validation
  validate :client_key_validation
  validate :service_id_validation

  # accepts_nested_attributes_for :entity_wallet_configs#, :activity_divs
  # accepts_nested_attributes_for :assigned_service_codes


  def secret_key_validation
    unless self.link_master == true
      unless self.s_key.present?
        logger.info "Existing Service Code Error ........................................................................."
        errors.add :s_key, " cannot be empty."
      end
    end
  end

  def client_key_validation
    unless self.link_master == true
      unless self.c_key.present?
        logger.info "Existing Service Code Error ........................................................................."
        errors.add :c_key, " cannot be empty."
      end
    end
  end

  def service_id_validation
    unless self.link_master == true
      unless self.serv_id.present?
        logger.info "Existing Service Code Error ........................................................................."
        errors.add :serv_id, " cannot be empty."
      end
    end
  end


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

  def self.hsh_key_validator(all_params)
    my_accepted_keys = []
    arr_all_params = all_params.keys
    arr_all_params.each do |prm|
      my_string = "the_activity_"
      if my_string.in? prm
        logger.info "Accepted key is:: #{prm.inspect}"
        my_accepted_keys << prm
      end
    end
    logger.info "Overall accepted keys :: #{my_accepted_keys.inspect}"
    my_accepted_keys
  end


  def self.check_string(str)
    str !~ /\D/
  end


  def self.division_setup_validation(params, main_param_keys, div_activity_type, entity_division_params)
    div_num = 0
    row_num = 0
    error_num = "0"
    valid_result = false
    if div_activity_type == "SHW" || div_activity_type == "SPO"
      if entity_division_params[:activity_query] == 'yes'
        if main_param_keys.any?
          main_param_keys.each_with_index do |main_param_key, ind|
            div_num = ind + 1
            activity_params = params["#{main_param_key}"]
            activity_params_size = activity_params.keys.size
            logger.info "Size class :: #{activity_params_size.class}"
            logger.info "Activity params #{main_param_key} at position #{div_num} size is :: #{activity_params_size.inspect}"
            activity_params.each do |key, value|
              if key == "0"
                unless value["activity_div_desc"].present? && value["activity_date"].present?
                  error_num = "1"
                  valid_result = false
                  break
                end
              elsif check_string(value)
                logger.info "=========== THE TIME SCHEDULE POINT. "
                row_num = row_num + 1
                if value["activity_time"].present? && value["classification"].present? && value["amount"].present?
                  valid_result = true
                elsif !value["activity_time"].present? && !value["classification"].present? && !value["amount"].present? && valid_result == false && activity_params_size == row_num + 1
                  logger.info "I am last empty and the the incoming validity was false...."
                  error_num = "3"
                  valid_result = false
                  break
                elsif !value["activity_time"].present? && !value["classification"].present? && !value["amount"].present?
                  logger.info "I am empty. ======================"
                else
                  logger.info "Some fields are left out."
                  error_num = "4"
                  valid_result = false
                  break
                end
              else
                logger.info "Params doesn't exist."
                error_num = "2"
                valid_result = false
                break
              end
            end
            if valid_result == false
              #error_num = "5"
              break
            else
              row_num = 0
            end
          end
        else
          logger.info "No activities were selected."
          error_num = "6"
          valid_result = false
        end
      else
        logger.info "Kindly choose an option for activities."
        valid_result = false
        error_num = "5"
      end
    else
      valid_result = true
    end

    return valid_result, error_num, div_num, row_num
  end


  def self.division_lov_validation(div_lov_params, division_code, entity_division_params, div_activity_type)
    lov_row_num = 0
    lov_error_num = "0"
    lov_validate_result = false

    count = 1
    if div_activity_type == "SHW" || div_activity_type == "SPO"
      lov_validate_result = true
    else

      if entity_division_params[:div_lov_query] == 'yes'
        if div_lov_params != nil
          div_lov_params_size = div_lov_params.keys.size
          logger.info "Division Lov Params Size is #{div_lov_params_size.inspect}"
          div_lov_params.each do |key, value|
            lov_row_num = lov_row_num + 1
            if division_code.present? && value["activity_code"].present? && value["lov_desc"].present?
              lov_validate_result = true
            elsif !value["activity_code"].present? && !value["lov_desc"].present? && lov_validate_result == false && div_lov_params_size == count
              lov_validate_result = false
              lov_error_num = "1"
              break
            elsif !value["activity_code"].present? && !value["lov_desc"].present?
            else
              logger.info "LOV:: Some fields are left out."
              lov_validate_result = false
              lov_error_num = "3"
              break
            end
            count = count + 1
          end
        else

          lov_validate_result = false
          lov_error_num = "2"
        end
      else
        logger.info "Kindly choose an option for div_lov."
        lov_validate_result = false
        lov_error_num = "4"
      end

    end

    return lov_validate_result, lov_error_num, lov_row_num
  end


  #def service_code_validation
  #  if self.service_code.present?
  #    logger.info "ME TOO I WAS HERE SOME..........................................."
  #    @service_code = AssignedServiceCode.where(service_code: self.service_code, active_status: true,
  #                                              del_status: false).order(created_at: :desc).first
  #    @active_service_code = AssignedServiceCode.where(entity_div_code: self.assigned_code, active_status: true,
  #                                              del_status: false).order(created_at: :desc).first
  #    if @service_code && @active_service_code != self.service_code
  #      logger.info "Existing Service Code Error ........................................................................."
  #      errors.add :service_code, " has already been taken."
  #    end
  #  end
  #end


  def service_code_validation
    if self.service_code.present?
      logger.info "ME TOO I WAS HERE SOME..........................................."
      @service_code = AssignedServiceCode.where("service_code = '#{self.service_code}' and entity_div_code != '#{self.assigned_code}' and active_status = true and
                                                del_status = false").order(created_at: :desc).first

      if @service_code
        logger.info "Existing Service Code Error  Updating ........................................................................."
        errors.add :service_code, " has already been taken."
      end
    end
  end


  def create_serv_code_validation
    if self.service_code.present?
      logger.info "ME TOO I WAS HERE SOME..........................................."
      @service_code = AssignedServiceCode.where("service_code = '#{self.service_code}' and active_status = true and
                                                del_status = false").order(created_at: :desc).first

      if @service_code
        logger.info "Existing Service Code Error ============= Creation ........................................................................."
        errors.add :service_code, " has already been taken."
      end
    end
  end


  def self.validate_entity_divisions(division_params, entity_div_params)
    division_validity = false
    service_code_exist = false
    incorrect_sender_id = false
    same_incoming_service_code = false
    master_wallet_exist = true
    incoming_service_code = []
    key_number = 0
    logger.info "Divisions Parameter Class #{division_params.class}"
    if division_params != nil && division_params.class == ActionController::Parameters
      logger.info "test 1"
      logger.info "Divisions Parameter Class #{division_params.class}"
      division_params.each do |key, value|

        if value["division_name"].present? || value["division_alias"].present? || value["sms_sender_id"].present? || value["service_label"].present? || value["service_code"].present? || value["activity_type_code"].present? || value["region_name"].present? || value["city_town_name"].present? || value["suburb_id"].present?
          logger.info "test 2"
          #@service_code = AssignedServiceCode.where(service_code: value["service_code"], active_status: true, del_status: false).order(created_at: :desc).first
          for_divisions = EntityDivision.new(entity_code: entity_div_params[:entity_code], activity_type_code: value["activity_type_code"], region_name: value["region_name"], city_town_name: value["city_town_name"],
                                             link_master: true, division_name: value["division_name"], service_label: value["service_label"], service_code: value["service_code"],
                                             suburb_id: value["suburb_id"], division_alias: value["division_alias"], sms_sender_id: value["sms_sender_id"], active_status: true, del_status: false)
          logger.info "object is #{for_divisions.inspect}"
          if for_divisions.valid?
            @entity_wallet_dependent = EntityWalletConfig.where("activity_type_code = '#{value["activity_type_code"]}' AND division_code IS NULL AND entity_code = '#{entity_div_params[:entity_code]}' AND active_status = true").order(created_at: :desc).first
            if @entity_wallet_dependent
              division_validity = true
            else
              logger.info "test 6"
              master_wallet_exist = false
              division_validity = false
              key_number = key
              break
            end
            #if @service_code
            #  logger.info "test 6"
            #  service_code_exist = true
            #  division_validity = false
            #  key_number = key
            #  break
            #else
            #  if incoming_service_code.include? (value["service_code"])
            #    same_incoming_service_code = true
            #    division_validity = false
            #    key_number = key
            #    break
            #  else
            #    incoming_service_code << value["service_code"]
            #    division_validity = true
            #  end
            #  logger.info "Incoming service code array :: #{incoming_service_code.inspect}"
            #end
          else

            if value["sms_sender_id"].size >= 3 && value["sms_sender_id"].size <= 9
              logger.info "VALIDITY Errors: #{for_divisions.errors.messages.inspect}"
              logger.info "test 3"
              division_validity = false
              key_number = key
              break
            else
              logger.info "test 7"
              division_validity = false
              key_number = key
              incorrect_sender_id = true
              break
            end
          end
        else
          logger.info "test 4"
          # division_validity = true
        end
      end
    else
      logger.info "test 5"
      division_validity = false
    end

    return division_validity, key_number, service_code_exist, same_incoming_service_code, incorrect_sender_id, master_wallet_exist
  end


  def self.save_entity_divisions(division_params, entity_div_params, current_user)
    division_params.each do |key, value|
      if value["division_name"].present? && value["division_alias"].present? && value["sms_sender_id"].present? && value["sms_sender_id"].size <= 9 && value["service_label"].present? && value["service_code"].present? && value["activity_type_code"].present? && value["region_name"].present? && value["city_town_name"].present? && value["suburb_id"].present?
        assigned_code = gen_entity_div_code
        if value.key?("allow_qr") && value["allow_qr"] == "on"
          for_divisions = EntityDivision.new(entity_code: entity_div_params[:entity_code], assigned_code: assigned_code, link_master: true,
                                             activity_type_code: value["activity_type_code"], division_name: value["division_name"],
                                             service_label: value["service_label"], suburb_id: value["suburb_id"], division_alias: value["division_alias"],
                                             sms_sender_id: value["sms_sender_id"], active_status: true, del_status: false,
                                             user_id: current_user.id, allow_qr: true)
        else
          for_divisions = EntityDivision.new(entity_code: entity_div_params[:entity_code], assigned_code: assigned_code, link_master: true,
                                             activity_type_code: value["activity_type_code"], division_name: value["division_name"],
                                             service_label: value["service_label"], suburb_id: value["suburb_id"], division_alias: value["division_alias"],
                                             sms_sender_id: value["sms_sender_id"], active_status: true, del_status: false,
                                             user_id: current_user.id, allow_qr: false)

        end

        for_service_codes = AssignedServiceCode.new(entity_div_code: assigned_code, service_code: value["service_code"],
                                                    active_status: true, del_status: false, user_id: current_user.id)
        for_divisions.save(validate: false)
        for_service_codes.save(validate: false)
      end
    end
  end


  def self.division_lov_save(div_lov_params, division_code, entity_division_params, current_user)

    if entity_division_params[:div_lov_query] == 'yes'
      if div_lov_params != nil
        div_lov_params_size = div_lov_params.keys.size
        logger.info "== Division Lov Params Size is #{div_lov_params_size.inspect}"
        div_lov_params.each do |key, value|
          if division_code.present? && value["activity_code"].present? && value["lov_desc"].present?
            logger.info "SAVING ..................."
            for_division_lov = DivisionActivityLov.new(activity_code: value["activity_code"], lov_desc: value["lov_desc"], user_id: current_user.id,
                                                       division_code: division_code, active_status: true, del_status: false)

            for_division_lov.save(validate: false)
          else
            logger.info "== LOV:: Some fields are left out."
          end
        end
      else
        logger.info "== No Data :: The rows are all deleted."
      end

    else
      logger.info "== Kindly choose an option for div_lov."
    end

  end


  def self.division_setup_save(params, main_param_keys, div_activity_type, entity_division_params, current_user)

    if div_activity_type == "SHW" || div_activity_type == "SPO"
      if entity_division_params[:activity_query] == 'yes'
        if main_param_keys.any?
          main_param_keys.each_with_index do |main_param_key, ind|
            activity_params = params["#{main_param_key}"]
            logger.info "Activity params #{main_param_key}"
            activity_div_id = 0
            activity_params.each do |key, value|
              if key == "0"
                if value["activity_div_desc"].present? && value["activity_date"].present?
                  logger.info "SAVING ........"
                  for_activity_div = ActivityDiv.new(activity_div_desc: value["activity_div_desc"], activity_date: value["activity_date"],
                                                     division_code: params[:code], active_status: true, del_status: false, user_id: current_user.id)

                  for_activity_div.save(validate: false)
                  activity_div_id = for_activity_div.id
                end
              elsif check_string(value)
                if value["activity_time"].present? && value["classification"].present? && value["amount"].present?
                  logger.info "SAVING ...... "
                  for_sub_activity_div = ActivitySubDiv.new(activity_div_id: activity_div_id, activity_time: value["activity_time"], classification: value["classification"],
                                                            amount: value["amount"], active_status: true, del_status: false)

                  for_sub_activity_div.save(validate: false)
                end
              else
              end
            end
          end
        else
          logger.info "== No activities were selected."
        end
      else
        logger.info "== Kindly choose an option for activities."
      end

    else
      logger.info "== Division Activities are not allowed for these."
    end
  end


  def self.division_setup_update(params, main_param_keys, div_activity_type, entity_division_params, current_user)

    if div_activity_type == "SHW" || div_activity_type == "SPO"
      if entity_division_params[:activity_query] == 'yes'
        if main_param_keys.any?
          activity_arr_ids = []
          @activity_div_obj = ActivityDiv.where(division_code: params[:code], active_status: true)
          activity_model_ids = object_ids(@activity_div_obj)

          main_param_keys.each_with_index do |main_param_key, ind|
            activity_params = params["#{main_param_key}"]
            logger.info "Activity params #{main_param_key}"
            activity_div_id = 0
            update_act_div_id = 0
            act_sub_arr_id = []
            act_sub_model_ids = []
            activity_params.each do |key, value|
              if key == "0"
                if value["activity_div_desc"].present? && value["activity_date"].present?
                  if value.key?("activity_id") && value["activity_id"].present?
                    activity_div = ActivityDiv.where(id: value["activity_id"], active_status: true).first
                    @activity_sub_div_obj = ActivitySubDiv.where(activity_div_id: value["activity_id"], active_status: true)
                    act_sub_model_ids = object_ids(@activity_sub_div_obj)
                    if activity_div
                      logger.info "=== UPDATE ACTIVITY ........"
                      activity_arr_ids << value["activity_id"].to_i
                      #activity_div.update!(activity_div_desc: value["activity_div_desc"], activity_date: value["activity_date"], user_id: current_user.id)
                      activity_div.activity_div_desc = value["activity_div_desc"]
                      activity_div.activity_date = value["activity_date"]
                      activity_div.user_id = current_user.id
                      activity_div.save(validate: false)
                    end
                    activity_div_id = value["activity_id"]
                    update_act_div_id = value["activity_id"].to_i
                  else
                    logger.info "=== SAVING ACTIVITY ........"
                    for_division_lov = ActivityDiv.new(activity_div_desc: value["activity_div_desc"], activity_date: value["activity_date"],
                                                       division_code: params[:code], active_status: true, del_status: false, user_id: current_user.id)

                    for_division_lov.save!(validate: false)
                    activity_div_id = for_division_lov.id
                  end
                end

              elsif check_string(value)
                if value["activity_time"].present? && value["classification"].present? && value["amount"].present?
                  if value.key?("activity_sub_id") && value["activity_sub_id"].present?
                    activity_sub_div = ActivitySubDiv.where(id: value["activity_sub_id"], active_status: true).first
                    if activity_sub_div
                      logger.info "=== UPDATING ...... "
                      act_sub_arr_id << value["activity_sub_id"].to_i
                      activity_sub_div.update!(activity_time: value["activity_time"], classification: value["classification"],
                                               amount: value["amount"], user_id: current_user.id)
                    end
                  else
                    logger.info "=== SAVING ...... "
                    for_division_lov = ActivitySubDiv.new(activity_div_id: activity_div_id, activity_time: value["activity_time"], classification: value["classification"],
                                                          amount: value["amount"], active_status: true, del_status: false, user_id: current_user.id)

                    for_division_lov.save!(validate: false)
                  end
                end
              else
              end
            end
            uncommon_act_ids = (act_sub_model_ids - act_sub_arr_id) | (act_sub_arr_id - act_sub_model_ids)
            delete_uncommon_obj_ids(uncommon_act_ids, @activity_sub_div_obj, "ASD")
          end
          uncommon_act_ids = (activity_model_ids - activity_arr_ids) | (activity_arr_ids - activity_model_ids)
          delete_uncommon_obj_ids(uncommon_act_ids, @activity_div_obj, "ACD")
        else
          logger.info "=== No activities were selected."
        end
      else
        logger.info "=== Kindly choose an option for activities."
      end

    else
      logger.info "=== Division Activities are not allowed for these activity codes."
    end
  end


  def self.object_ids(model_obj)
    model_obj.exists? ? model_obj.map { |a| a.id } : []
  end

  def self.arr_params_lov_ids(div_lov_params, params_type)
    arr_ids = []
    div_lov_params.each do |key, value|
      if params_type == "LOV"
        if value["activity_code"].present? && value["lov_desc"].present?
          if value.key?("id") && value["id"].present?
            arr_ids << value["id"].to_i
          end
        end
      elsif params_type == "ACD"
        if value["activity_div_desc"].present? && value["activity_date"].present?
          if value.key?("activity_id") && value["activity_id"].present?
            arr_ids << value["activity_id"].to_i
          end
        end
      elsif params_type == "ASD"
        if value["activity_time"].present? && value["classification"].present? && value["amount"].present?
          if value.key?("activity_sub_id") && value["activity_sub_id"].present?
            arr_ids << value["activity_sub_id"].to_i
          end
        end
      else
        logger.info "============== PARAMS TYPE WAS NOT ABLE TO MATCH. =============="
      end
    end
    arr_ids
  end

  def self.delete_uncommon_obj_ids(uncommon_ids, active_object, params_type)
    if uncommon_ids.any?
      uncommon_ids.each do |uncommon_id|
        if params_type == "LOV"
          logger.info "For LOV"
          unique_obj = active_object.where(id: uncommon_id).first
        elsif params_type == "ACD"
          logger.info "For ACD"
          unique_obj = active_object.where(id: uncommon_id).first
        elsif params_type == "ASD"
          logger.info "For ASD"
          unique_obj = active_object.where(id: uncommon_id).first
        else
          logger.info "Out of Range.."
          unique_obj = 0
        end

        if unique_obj && unique_obj != 0
          unique_obj.active_status = false
          unique_obj.del_status = true
          unique_obj.save!(validate: false)
        else
          logger.info "This division lov is not in the table."
        end
      end
    else
      logger.info "There were no uncommon ids."
    end
  end


  def self.division_lov_update(div_lov_params, division_code, entity_division_params, current_user)
    if entity_division_params[:div_lov_query] == 'yes'
      if div_lov_params != nil
        div_lov_params_size = div_lov_params.keys.size
        logger.info "=== Division Lov Params Size is #{div_lov_params_size.inspect}"
        @division_activity_lov = DivisionActivityLov.where(division_code: division_code, active_status: true)
        lov_id_arr = object_ids(@division_activity_lov)
        arr_ids = []
        div_lov_params.each do |key, value|
          if division_code.present? && value["activity_code"].present? && value["lov_desc"].present?
            if value.key?("id") && value["id"].present?
              arr_ids << value["id"].to_i
              division_activity_lov = DivisionActivityLov.where(id: value["id"], active_status: true).first
              if division_activity_lov
                logger.info "=== UPDATING Division LOV ..................."
                division_activity_lov.update!(activity_code: value["activity_code"], lov_desc: value["lov_desc"], user_id: current_user.id)
                #division_activity_lov.activity_code = value["activity_code"]
                #division_activity_lov.lov_desc = value["lov_desc"]
                #division_activity_lov.save(validate: false)
              end
            else
              logger.info "=== SAVING Division LOV ..................."
              for_division_lov = DivisionActivityLov.new(activity_code: value["activity_code"], lov_desc: value["lov_desc"],
                                                         division_code: division_code, active_status: true, del_status: false, user_id: current_user.id)

              for_division_lov.save!(validate: false)
            end
          else
            logger.info "=== LOV:: Some fields are left out."
          end
        end
        uncommon_ids = (lov_id_arr - arr_ids) | (arr_ids - lov_id_arr)
        delete_uncommon_obj_ids(uncommon_ids, @division_activity_lov, "LOV")
      else
        logger.info "=== No Data :: The rows are all deleted."
      end
    else
      logger.info "=== Kindly choose an option for div_lov."
    end
  end


  def self.update_last_but_one(table, id_field, id)
    sql = "UPDATE #{table} SET active_status = false, del_status = true WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND active_status = true AND del_status = false order by id asc LIMIT 1)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end

  def self.disable_by_update_onef(table, id_field, id)
    sql = "UPDATE #{table} SET active_status = false WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND active_status = true AND del_status = false)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end

  def self.enable_by_update_onet(table, id_field, id)
    sql = "UPDATE #{table} SET active_status = true WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND active_status = false AND del_status = false)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end


end