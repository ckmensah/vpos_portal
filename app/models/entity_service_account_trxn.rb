class EntityServiceAccountTrxn < ApplicationRecord
  self.table_name="entity_service_account_trxn"
  self.primary_key = "processing_id"

  belongs_to :entity_division, class_name: "EntityDivision", foreign_key: :entity_div_code

  def self.wallet_join
    select("trans_type, to_char(created_at, 'YYYY-MM-DD') AS date, sum((net_bal_aft - net_bal_bef)) AS actual_amt")
  end

  def self.credit_total
    select"(sum((net_bal_aft - net_bal_bef)) AS amount) from entity_service_account_trxn"
  end

  def self.debit_total
    select"(sum((net_bal_aft - net_bal_bef)) AS amt) from funds_movement"
  end

  def self.closing_bal_n_bbf(start_date, end_date, division_code)
    closing_bal = 0.000
    balance_bf = 0.000
    @entity_service_trxn_cb = EntityServiceAccountTrxn.where("entity_div_code = '#{division_code}' and created_at between '#{start_date} 00:00:00' and '#{end_date} 23:59:59'").order(created_at: :desc).first
    @entity_service_trxn_bbf = EntityServiceAccountTrxn.where("entity_div_code = '#{division_code}' and created_at < '#{start_date} 00:00:00'").order(created_at: :desc).first
    closing_bal = @entity_service_trxn_cb.net_bal_aft.round(3) if @entity_service_trxn_cb
    balance_bf = @entity_service_trxn_bbf.net_bal_aft.round(3) if @entity_service_trxn_bbf
    return balance_bf, closing_bal
  end
end
