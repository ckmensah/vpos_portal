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
    if start_date.present? && end_date.present? && division_code.present?
      @entity_service_trxn_cb = EntityServiceAccountTrxn.where("entity_div_code = '#{division_code}' and created_at between '#{start_date} 00:00:00' and '#{end_date} 23:59:59'").order(created_at: :desc).first
      @entity_service_trxn_bbf = EntityServiceAccountTrxn.where("entity_div_code = '#{division_code}' and created_at < '#{start_date} 00:00:00'").order(created_at: :desc).first
      closing_bal = @entity_service_trxn_cb.net_bal_aft.round(3) if @entity_service_trxn_cb
      balance_bf = @entity_service_trxn_bbf.net_bal_aft.round(3) if @entity_service_trxn_bbf
    end
    return balance_bf, closing_bal
  end


  def self.to_finance_csv(payment_report, fund_movements, fund_moves, service_name, balance_bf, options = "")
    CSV.generate(options) do |csv|
      headers = %w{Value_Date Description Debit Credit Balance}
      balance = balance_bf
      csv << headers
      if payment_report.first
        payment_report.each_with_index do |pay_report, index|
          # ------code comes here

          logger.info "Payment report :: #{index + 1}. #{pay_report.inspect}"
          if fund_movements.first
            if index == 0
              fund_movements.each_with_index do |fund_movement, index1|
                logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
                if fund_movement.date.to_date < pay_report.date.to_date
                  date = fund_movement.date
                  narration = fund_movement.narration
                  debit_amt = fund_movement.amt
                  credit_amt = ""
                  balance = balance - debit_amt
                  csv << [date, narration, debit_amt, credit_amt, balance]
                end
              end
            else
              fund_movements.each_with_index do |fund_movement, index1|
                logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
                if fund_movement.date.to_date < pay_report.date.to_date && fund_movement.date.to_date >= payment_report[index - 1].date.to_date
                  date = fund_movement.date
                  narration = fund_movement.narration
                  debit_amt = fund_movement.amt
                  credit_amt = ""
                  balance = balance - debit_amt
                  csv << [date, narration, debit_amt, credit_amt, balance]
                end
              end
            end
          end


          date = pay_report.date
          #narration = "Collections for #{pay_report.date.to_date.strftime("%B %d, %Y")}"

          if pay_report.trans_type == 'CTM'
            narration = "Collections for #{pay_report.date.to_date.strftime("%B %d, %Y")}"
          else
            fund_moves1 = fund_moves.where("entity_div_code IN #{service_name} AND trans_type = '#{pay_report.trans_type}' AND created_at BETWEEN '#{pay_report.date} 00:00:00' AND '#{pay_report.date} 23:59:59'").group("trans_type, narration, date").order(date: :asc).first
            if fund_moves1
              logger.info "Narration of Collection Credit is from Fund_movement table ==================="
              narration = fund_moves1.narration
            else
              narration = "Collections for #{pay_report.date.to_date.strftime("%B %d, %Y")}"
            end
          end

          debit_amt = ""
          credit_amt = pay_report.actual_amt
          balance = balance + credit_amt
          csv << [date, narration, debit_amt, credit_amt, balance]



          if fund_movements.first
            fund_movements.each_with_index do |fund_movement, index1|
              logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
              if payment_report.size.to_i == index + 1 && fund_movement.date.to_date >= pay_report.date.to_date
                date = fund_movement.date
                narration = fund_movement.narration
                debit_amt = fund_movement.amt
                credit_amt = ""
                balance = balance - debit_amt
                csv << [date, narration, debit_amt, credit_amt, balance]
              end
            end
          end
        end
      else
        if fund_movements.first
          fund_movements.each_with_index do |fund_movement, index1|
            logger.info "Fund Movement report :: #{index1 + 1}. #{fund_movement.inspect}"
            date = fund_movement.date
            narration = fund_movement.narration
            debit_amt = fund_movement.amt
            credit_amt = ""
            balance = balance - debit_amt
            csv << [date, narration, debit_amt, credit_amt, balance]
          end
        end
      end

    end

  end


end
