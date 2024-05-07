class EntityDivision < ApplicationRecord
  self.table_name = "entity_division"
  self.primary_key = :assigned_code
  attr_accessor :region_name, :city_town_name, :service_code, :action_type, :for_update, :div_lov_query, :activity_query,
                :sub_activity_query, :serv_id, :s_key, :c_key, :sport_type, :sport_category, :category_type, :for_fixture,
                :company_code, :company_url
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
  has_many :fund_movements, class_name: "FundMovement", foreign_key: :entity_div_code
  has_many :entity_div_alert_recipients, class_name: "EntityDivAlertRecipient", foreign_key: :entity_div_code
  has_many :entity_div_media, class_name: "EntityDivMedium", foreign_key: :entity_div_code
  has_many :entity_div_social_handles, class_name: "EntityDivSocialHandle", foreign_key: :entity_div_code
  has_many :loan_requests, class_name: 'LoanRequest', foreign_key: :division_code
  has_many :client_webhook_configs, class_name: 'ClientWebhookConfig', foreign_key: :entity_div_code
  has_many :entity_div_ref_lookups, class_name: 'EntityDivRefLookup', foreign_key: :entity_div_code

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
  validates :service_code, presence: {message: " cannot be empty."}, format: {with: /\A\d+\z/, message: "must be numbers only."}, length: {minimum: 1, maximum: 6}
  #validate :service_code_validation, :if => :for_update
  #validate :create_serv_code_validation, :unless => :for_update
  validate :secret_key_validation
  validate :client_key_validation
  validate :service_id_validation
  validate :merchant_wallet_validity, :if => :for_update


  # accepts_nested_attributes_for :entity_wallet_configs#, :activity_divs
  # accepts_nested_attributes_for :assigned_service_codes



  def self.gather_all_assigned_code(all_services)
    assigned_code_arr = []
    all_services.each_with_index do |service, index|
      logger.info "#{index + 1}. Merchant :: #{service.inspect} and Assigned Code :: #{service.assigned_code.inspect}"
      unless assigned_code_arr.include?("#{service.assigned_code}")
        assigned_code_arr << "#{service.assigned_code}"
      end
    end
    logger.info "Assigned Code Array :: #{assigned_code_arr.inspect}"
    assigned_code_arr
  end



  def self.same_created_at(all_services)
    assigned_code_arr = gather_all_assigned_code(all_services)
    if assigned_code_arr.any?
      assigned_code_arr.each_with_index do |assigned_code, index|
        logger.info "#{index + 1}. Assigned Code = #{assigned_code.inspect}"
        service_objs = EntityDivision.where(assigned_code: assigned_code).order(created_at: :desc)
        first_insertion = service_objs.last

        for_date = EntityDivision.find_by_sql("select * from entity_division where assigned_code = '#{assigned_code}' order by id asc limit 1")[0]
        logger.info "#{index + 1}FOR DATE: #{for_date.inspect}"
        if first_insertion
          logger.info "New Date :: #{first_insertion.created_at.strftime('%Y-%m-%d %H:%M:%S.%N')}"
          logger.info "New SQL Date :: #{for_date.created_at.strftime('%Y-%m-%d %H:%M:%S.%N')}"

          sql = "UPDATE entity_division SET created_at = '#{first_insertion.created_at.strftime('%Y-%m-%d %H:%M:%S.%N')}' WHERE id IN (SELECT id FROM entity_division WHERE assigned_code = '#{assigned_code}')"
          val = ActiveRecord::Base.connection.execute(sql)


          #service_objs.each_with_index do |service_obj, index1|
          #  logger.info "#{index1 + 1}. Original Date: #{service_obj.created_at} and New Date: #{first_insertion.created_at}"
          #  service_obj.created_at = first_insertion.created_at
          #  service_obj.save(validate: false)
          #end
        end

      end
    end

  end


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

  def merchant_wallet_validity
    if self.link_master == true && self.activity_type_code.present?
      merchant_wallet = EntityWalletConfig.where(entity_info: self.entity_code, activity_type_code: self.activity_type_code,
                                                 active_status: true, del_status: false).order(created_at: :desc).first

      unless merchant_wallet
        logger.info "Wallet for this activity_type #{self.activity_type_code} does not exist in the merchant table ........................................................................."
        errors.add :activity_type_code, " (#{self.activity_type_code}) has no associated merchant wallet."
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

  def self.media_upload_validity(div_med_params, div_code)
    valid_image = true
    selected = true
    if div_med_params[:media_type] == "IMG"
      if div_med_params.key?(:media_data)
        # div_med_params[:media_data].each_with_index do |image, ind|
          filename = div_med_params[:media_data]
          logger.info "Media IMG ==== 1 #{filename.inspect}"
          # logger.info "#{ind + 1}. Media IMG ==== 2 #{filename.inspect}"
        @entity_division = EntityDivision.new(media_type: div_med_params[:media_type],
                                              media_path: div_med_params[:media_path],
                                              media_data: filename, division_name: div_med_params[:division_name],
                                              ref_label: div_med_params[:ref_label],assigned_code: div_code,
                                              division_alias: div_med_params[:division_alias],
                                              suburb_id: div_med_params[:suburb_id], activity_type_code: div_med_params[:activity_type_code],
                                              service_label: div_med_params[:service_label], service_code: div_med_params[:service_code],
                                              allow_qr: div_med_params[:allow_qr], msg_sender_id: div_med_params[:msg_sender_id],
                                              sms_sender_id: div_med_params[:sms_sender_id], link_master: div_med_params[:link_master],
                                              min_amount: div_med_params[:min_amount], activity_loc: div_med_params[:activity_loc],
                                              extra_desc: div_med_params[:extra_desc], payment_type: div_med_params[:payment_type],
                                              entity_code: div_med_params[:entity_code], serv_id: div_med_params[:serv_id],
                                              s_key: div_med_params[:s_key], c_key: div_med_params[:c_key],
                                              city_town_name: div_med_params[:city_town_name], region_name: div_med_params[:region_name],
                                              card_option_status: div_med_params[:card_option_status], division_category: div_med_params[:division_category],
                                              event_progress: div_med_params[:event_progress],active_status: true, del_status: false)

          logger.info "Media IMG ==== 2 check the validity of the object #{@entity_division.media_data.inspect} #################################"
          logger.info "Media IMG ==== 2 check the error messages of the object #{@entity_division.errors.messages} #################################"

          unless @entity_division.valid?
            valid_image = false
           else
            valid_image = true
            # break
          end
        # end
      else
        #valid_image = false
        selected = false
      end
    end
    return valid_image, selected
  end



  def self.media_upload_save(div_med_params, media_uploader, div_code, current_user)
    if div_med_params[:media_type] == "IMG"
      puts "this is the class of the object#{div_med_params.class}"
      if div_med_params.key?(:media_data)
        # div_med_params[:media_data].each_with_index do |image, ind|
          img_public_id = media_uploader.service_logo_pub_id(div_med_params[:media_type])
          filename = media_uploader.filename_logo(div_med_params[:media_data], img_public_id)
          logger.info "1. Media ==== TELL ME THE FILENAME I'M SAVING #{filename.inspect} ##########################"
          # logger.info "#{ind + 1}. Media ==== 2 #{filename.inspect}"
        @entity_division = EntityDivision.new(media_type: div_med_params[:media_type],
                                              media_path: div_med_params[:media_path],
                                              media_data: filename, division_name: div_med_params[:division_name],
                                              ref_label: div_med_params[:ref_label], assigned_code: div_code,
                                              division_alias: div_med_params[:division_alias],
                                              reference: div_med_params[:reference],
                                              suburb_id: div_med_params[:suburb_id], activity_type_code: div_med_params[:activity_type_code],
                                              service_label: div_med_params[:service_label], service_code: div_med_params[:service_code],
                                              allow_qr: div_med_params[:allow_qr], msg_sender_id: div_med_params[:msg_sender_id],
                                              sms_sender_id: div_med_params[:sms_sender_id], link_master: div_med_params[:link_master],
                                              min_amount: div_med_params[:min_amount], activity_loc: div_med_params[:activity_loc],
                                              extra_desc: div_med_params[:extra_desc], payment_type: div_med_params[:payment_type],
                                              entity_code: div_med_params[:entity_code], serv_id: div_med_params[:serv_id],
                                              s_key: div_med_params[:s_key], c_key: div_med_params[:c_key],
                                              city_town_name: div_med_params[:city_town_name], region_name: div_med_params[:region_name],
                                              card_option_status: div_med_params[:card_option_status], division_category: div_med_params[:division_category],
                                              event_progress: div_med_params[:event_progress],active_status: true, del_status: false, user_id: current_user)
          logger.info "Media ==== 3 #{@entity_division.media_data.inspect}"
          # logger.info "#{ind + 1}. Media ==== 3 #{@entity_division.media_data.inspect}"
          # resource_type: div_med_params[:media_data]
          @entity_division.save(validate: false)
          if @entity_division.save
            Cloudinary::Uploader.upload(div_med_params[:media_data], :public_id => img_public_id)
          else
            logger.info "Image Couldn't Save"
          end
        # end
      end
    end

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


  def self.division_lov_validation(div_lov_params, division_code, entity_division_params, div_activity_type, validate_action)
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
          if validate_action == "UPDATE"
            lov_validate_result = true
          else
            lov_validate_result = false
          end
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

        if value["activity_type_code"] == "HSP"
          if value.key?("payment_type") && value["payment_type"] == "on" && value.key?("card_option_status") && value["card_option_status"] == "on"
            for_divisions = EntityDivision.new(entity_code: entity_div_params[:entity_code], assigned_code: assigned_code, link_master: true,
                                               activity_type_code: value["activity_type_code"], division_name: value["division_name"],
                                               service_label: value["service_label"], suburb_id: value["suburb_id"], division_alias: value["division_alias"],
                                               sms_sender_id: value["sms_sender_id"], active_status: true, del_status: false,
                                               user_id: current_user.id, allow_qr: false, payment_type: true, card_option_status: true)
          elsif value.key?("payment_type") && value["payment_type"] == "on" || value.key?("card_option_status") && value["card_option_status"] == "on"
            payment_type = value["payment_type"] == "on" ? true : false
            card_option_status = value["card_option_status"] == "on" ? true : false
            for_divisions = EntityDivision.new(entity_code: entity_div_params[:entity_code], assigned_code: assigned_code, link_master: true,
                                               activity_type_code: value["activity_type_code"], division_name: value["division_name"],
                                               service_label: value["service_label"], suburb_id: value["suburb_id"], division_alias: value["division_alias"],
                                               sms_sender_id: value["sms_sender_id"], active_status: true, del_status: false,
                                               user_id: current_user.id, allow_qr: false, payment_type: payment_type, card_option_status: card_option_status)
          else
            for_divisions = EntityDivision.new(entity_code: entity_div_params[:entity_code], assigned_code: assigned_code, link_master: true,
                                               activity_type_code: value["activity_type_code"], division_name: value["division_name"],
                                               service_label: value["service_label"], suburb_id: value["suburb_id"], division_alias: value["division_alias"],
                                               sms_sender_id: value["sms_sender_id"], active_status: true, del_status: false,
                                               user_id: current_user.id, allow_qr: false, payment_type: false)

          end
        else
          if value.key?("allow_qr") && value["allow_qr"] == "on"
            for_divisions = EntityDivision.new(entity_code: entity_div_params[:entity_code], assigned_code: assigned_code, link_master: true,
                                               activity_type_code: value["activity_type_code"], division_name: value["division_name"],
                                               service_label: value["service_label"], suburb_id: value["suburb_id"], division_alias: value["division_alias"],
                                               sms_sender_id: value["sms_sender_id"], active_status: true, del_status: false,
                                               user_id: current_user.id, allow_qr: true, payment_type: false)
          else
            for_divisions = EntityDivision.new(entity_code: entity_div_params[:entity_code], assigned_code: assigned_code, link_master: true,
                                               activity_type_code: value["activity_type_code"], division_name: value["division_name"],
                                               service_label: value["service_label"], suburb_id: value["suburb_id"], division_alias: value["division_alias"],
                                               sms_sender_id: value["sms_sender_id"], active_status: true, del_status: false,
                                               user_id: current_user.id, allow_qr: false, payment_type: false)

          end
        end

        for_service_codes = AssignedServiceCode.new(entity_div_code: assigned_code, service_code: value["service_code"],
                                                    active_status: true, del_status: false, user_id: current_user.id)
        for_divisions.save(validate: false)
        for_service_codes.save(validate: false)
      end
    end
  end


  def self.entity_event_instance(entity_div_obj, current_user)
    EntityDivision.new(entity_code: entity_div_obj.entity_code, assigned_code: entity_div_obj.assigned_code,
                       division_name: entity_div_obj.division_name, division_alias: entity_div_obj.division_alias,
                       suburb_id: entity_div_obj.suburb_id, activity_type_code: entity_div_obj.activity_type_code,
                       service_label: entity_div_obj.service_label, user_id: current_user.id, active_status: true,
                       del_status: false, allow_qr: entity_div_obj.allow_qr,
                       msg_sender_id: entity_div_obj.msg_sender_id, sms_sender_id: entity_div_obj.sms_sender_id,
                       link_master: entity_div_obj.link_master, min_amount: entity_div_obj.min_amount,
                       extra_desc: entity_div_obj.extra_desc, activity_loc: entity_div_obj.activity_loc,
                       payment_type: entity_div_obj.payment_type, card_option_status: entity_div_obj.card_option_status)
  end

  def self.event_state(entity_div_obj, current_user)
    event_feedback = nil
    entity_div_obj.active_status = false
    entity_div_obj.del_status = true
    entity_div_obj.save(validate: false)
    entity_division = entity_event_instance(entity_div_obj, current_user)
    if entity_div_obj.event_progress
      event_feedback = "end_event"
      entity_division.event_progress = false
    elsif entity_div_obj.event_progress == false
      event_feedback = "start_event"
      entity_division.event_progress = true
    end
    entity_division.save(validate: false)

    event_feedback
  end



  def self.division_lov_save(div_lov_params, division_code, entity_division_params, current_user)

    if entity_division_params[:div_lov_query] == 'yes'
      if div_lov_params != nil
        div_lov_params_size = div_lov_params.keys.size
        logger.info "== Division Lov Params Size is #{div_lov_params_size.inspect}"
        div_lov_params.each do |key, value|
          if division_code.present? && value["activity_code"].present? && value["lov_desc"].present?
            logger.info "SAVING ..................."
            if value.key?("assigned_amount")
              for_division_lov = DivisionActivityLov.new(activity_code: value["activity_code"], lov_desc: value["lov_desc"], user_id: current_user.id,
                                                         division_code: division_code, assigned_amount: value["assigned_amount"], active_status: true, del_status: false)

            else
              for_division_lov = DivisionActivityLov.new(activity_code: value["activity_code"], lov_desc: value["lov_desc"], user_id: current_user.id,
                                                         division_code: division_code, assigned_amount: nil, active_status: true, del_status: false)

            end

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

  def self.delete_all_lovs(active_lov_obj)
    if active_lov_obj.exists?
      active_lov_obj.each do |active_lov|
        logger.info "This division lov is to be DELETED.........."
        logger.info "This :: #{active_lov.inspect}"
        active_lov.active_status = false
        active_lov.del_status = true
        active_lov.save!(validate: false)
      end
    else
      logger.info "NO LOV RECORD TO DELETE =================="
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
                if value.key?("assigned_amount")
                  division_activity_lov.update!(activity_code: value["activity_code"], assigned_amount: value["assigned_amount"], lov_desc: value["lov_desc"], user_id: current_user.id)
                else
                  division_activity_lov.update!(activity_code: value["activity_code"], assigned_amount: nil, lov_desc: value["lov_desc"], user_id: current_user.id)
                end
                #division_activity_lov.activity_code = value["activity_code"]
                #division_activity_lov.lov_desc = value["lov_desc"]
                #division_activity_lov.save(validate: false)
              end
            else
              logger.info "=== SAVING Division LOV ..................."

              if value.key?("assigned_amount")
                for_division_lov = DivisionActivityLov.new(activity_code: value["activity_code"], lov_desc: value["lov_desc"], user_id: current_user.id,
                                                           division_code: division_code, assigned_amount: value["assigned_amount"], active_status: true, del_status: false)

              else
                for_division_lov = DivisionActivityLov.new(activity_code: value["activity_code"], lov_desc: value["lov_desc"],
                                                           division_code: division_code, assigned_amount: nil, active_status: true, del_status: false, user_id: current_user.id)

              end

              for_division_lov.save!(validate: false)
            end
          else
            logger.info "=== LOV:: Some fields are left out."
          end
        end
        uncommon_ids = (lov_id_arr - arr_ids) | (arr_ids - lov_id_arr)
        delete_uncommon_obj_ids(uncommon_ids, @division_activity_lov, "LOV")
      else
        @division_act_lov = DivisionActivityLov.where(division_code: division_code, active_status: true)
        delete_all_lovs(@division_act_lov)
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