class EntityAdminWhitelist < ApplicationRecord
  self.table_name = "entity_admin_whitelist"
  self.primary_key = :mobile_number
  attr_accessor :for_whitelist_update

  belongs_to :entity_division, class_name: "EntityDivision", foreign_key: :entity_division_code
  CTRYCODE = "233"

  validates :entity_division_code, presence: {message: " cannot be empty."}
  validates :full_name, presence: {message: " cannot be empty."}
  validates :mobile_number, presence: {message: " cannot be empty."}
  #validate :mobile_number_validation, if: :for_whitelist_update


  def mobile_number_validation
    mobile_num = EntityAdminWhitelist.break_number(self.mobile_number)
    logger.info "Mobile Number is #{mobile_num.inspect}"
    if EntityAdminWhitelist.is_number?(mobile_num) && mobile_num.length == 12
      entity_admin = EntityAdminWhitelist.where(active_status: true, del_status: false, mobile_number: mobile_num,
                                                entity_division_code: self.entity_division_code).
          order(created_at: :desc).first
      unless entity_admin
        errors.add :mobile_number, " already in existence for this service."
      end
    else
      errors.add :mobile_number, " is incorrect."
    end

  end


  def self.break_number(mobile_number)
    wildcard_search = "#{mobile_number}"
    if wildcard_search[0..2]=='233' && wildcard_search.length==12
      wildcard_search=CTRYCODE+"#{wildcard_search[3..wildcard_search.length]}"
    elsif wildcard_search[0]=='0' && wildcard_search.length==10
      wildcard_search=CTRYCODE+"#{wildcard_search[1..wildcard_search.length]}"
    elsif wildcard_search[0]=='+' && wildcard_search[1..3]=='233'&& wildcard_search[4..wildcard_search.length].length==9
      wildcard_search=CTRYCODE+"#{wildcard_search[4..wildcard_search.length]}"
    elsif wildcard_search[0]!="+" && wildcard_search[0..2]!='233' && wildcard_search.length==9
      wildcard_search=CTRYCODE+"#{wildcard_search[0..wildcard_search.length]}"
    else
      #wildcard_search
    end
  end


  def self.is_number?(string)
    true if Float(string) rescue false
  end

  def self.validate_admin_whitelists(whitelist_params, admin_whitelist_params)
    admin_whitelist_validity = false
    not_empty = false
    valid_mobile_num = true
    existing_mob_num = false
    key_number = 0
    logger.info "Whitelist Parameter Class #{whitelist_params.class}"
    if whitelist_params != nil && whitelist_params.class == ActionController::Parameters
      logger.info "test 1"
      logger.info "Whitelist Parameter Class #{whitelist_params.class}"
      whitelist_params.each do |key, value|
        if value["full_name"].present? || value["mobile_number"].present? #|| admin_whitelist_params[:entity_division_code].present?
          logger.info "test 2"
          not_empty = true
          for_admin_whitelists = EntityAdminWhitelist.new(entity_division_code: admin_whitelist_params[:entity_division_code],
                                                    full_name: value["full_name"], mobile_number: value["mobile_number"],
                                                    active_status: true, del_status: false)
          logger.info "object is #{for_admin_whitelists.inspect}"
          if for_admin_whitelists.valid?
            mobile_num = break_number(value["mobile_number"])
            logger.info "Mobile Number is #{mobile_num.inspect}"
            if is_number?(mobile_num) && mobile_num.length == 12
              entity_admin = EntityAdminWhitelist.where(active_status: true, del_status: false, mobile_number: mobile_num,
                                                        entity_division_code: admin_whitelist_params[:entity_division_code]).
                  order(created_at: :desc).first
              if entity_admin
                logger.info "Mobile Number already in existence for this service: #{mobile_num.inspect}"
                logger.info "test 7"
                existing_mob_num = true
                admin_whitelist_validity = false
                key_number = key
                break
              else
                admin_whitelist_validity = true
              end
            else
              logger.info "Mobile Number: #{mobile_num.inspect}"
              logger.info "test 6"
              valid_mobile_num = false
              admin_whitelist_validity = false
              key_number = key
              break
            end
          else
            logger.info "VALIDITY Errors: #{for_admin_whitelists.errors.messages.inspect}"
            logger.info "test 3"
            admin_whitelist_validity = false
            key_number = key
            break
          end
        else
          logger.info "test 4"
          # division_validity = true
        end
      end
    else
      logger.info "test 5"
      admin_whitelist_validity = false
    end

    return admin_whitelist_validity, key_number, not_empty, valid_mobile_num, existing_mob_num

  end


  def self.save_admin_whitelists(whitelist_params, admin_whitelist_params, current_user)
    whitelist_params.each do |key, value|
      if value["full_name"].present? && value["mobile_number"].present? && admin_whitelist_params["entity_division_code"].present?
        mobile_num = break_number(value["mobile_number"])
        for_admin_whitelists = EntityAdminWhitelist.new(entity_division_code: admin_whitelist_params["entity_division_code"],
                                                  full_name: value["full_name"], mobile_number: mobile_num,
                                                  active_status: true, del_status: false, user_id: current_user.id)

        for_admin_whitelists.save(validate: false)
      end
    end
  end


  def self.update_last_but_one(table, id_field, id, div_code)
    sql = "UPDATE #{table} SET active_status = false, del_status = true WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND entity_division_code = '#{div_code}' AND active_status = true AND del_status = false order by id asc LIMIT 1)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end

  def self.delete_by_update_onef(table, id_field, id, div_code)
    sql = "UPDATE #{table} SET active_status = false, del_status = true WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}'AND entity_division_code = '#{div_code}' AND active_status = true AND del_status = false)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end

  def self.disable_by_update_onef(table, id_field, id, div_code)
    sql = "UPDATE #{table} SET active_status = false WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}'AND entity_division_code = #{div_code} AND active_status = true AND del_status = false)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end

  def self.enable_by_update_onet(table, id_field, id, div_code)
    sql = "UPDATE #{table} SET active_status = true WHERE id = (SELECT id FROM #{table} WHERE #{id_field} = '#{id}' AND entity_division_code = #{div_code} AND active_status = false AND del_status = false)"
    val = ActiveRecord::Base.connection.execute(sql)
    #logger "VALUE: #{val.inspect}"
  end



end
