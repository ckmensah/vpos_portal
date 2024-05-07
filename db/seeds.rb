# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#User.create!(user_name: "test", last_name: "Nartey", first_name: "Francis", password: "gibbor123", password_confirmation: "gibbor123", contact_number: "0555283600", email: "narteyf7@gmail.com")

require 'csv'
# require_relative ''

the_file =  './public/kedagh.csv'
CSV.foreach(the_file, headers: true, encoding: 'windows-1251:utf-8') do |row|
  the_services=["1217","1218","1219"].freeze
  the_services.each do |service|
    unique_identifier = row['momo_number'].split(//).last(9).join
    existing_record = EntityDivRefLookup.where("right(pan,9) = '#{unique_identifier}' and entity_div_code= '#{service}'").order(created_at: :desc).first
    # Check if a record with the unique identifier already exists
    # existing_record = model.find_by(unique_column: unique_identifier)
    # model.create!(row.to_hash)
    if existing_record.present?
      # Update the existing record if it already exists
      existing_record.update!(pan: row['momo_number'], entity_div_code: service, name: row['customer_crm_name'], active_status: true, del_status: false)
      # existing_record.update!(row.to_hash)
      # puts "Updated record with #{unique_identifier}"
      puts "Updated record with #{existing_record}"
    else
      # Create a new record if it doesn't exist
      new_record = EntityDivRefLookup.create!(pan: row['momo_number'], entity_div_code: service,  name: row['customer_crm_name'], active_status: true, del_status: false)
      # model.create!(row.to_hash)
      puts "Inserted record with #{new_record}"
    end
  end
end
