require 'prawn'
class FinancialStatementPdf < Prawn::Document
  # require 'active_record'
  # require 'active_support/core_ext'
  def initialize(financial_statement, fund_movements,  div_name, start_date, end_date, logger, options = {}, &block)
    # super :page_size => "A4", :page_layout => :landscape
    super options
    # super(top_margin: 70)
    @financial_statement = financial_statement
    @logger = logger
    @fund_movements = fund_movements
    @div_name = div_name
    @start_date = start_date
    @end_date = end_date
    to_pdf
  end


  # def self.to_pdf(perpage, page)
  def to_pdf
    @logger.info "Table data is #{pdf_records.inspect}"
    table pdf_records do
      self.cell_style = { size: 10 }
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.width = 760
      # self.column_widths = [40, 300, 200]
    end

  end

  # def self.pdf_records(perpage, page)
  def pdf_records

    data = [['','STATEMENT ON COLLECTIONS WALLET','',''],['NAME OF SERVICE:', "#{@div_name}",'',''],['DATE RANGE:', "#{@start_date.to_date.strftime("%B %d, %Y")} TO #{@end_date.to_date.strftime("%B %d, %Y")}",'',''],['Value_Date', 'Description', 'Sweeps/Debit', 'Collections/Credit']]

    @financial_statement.each_with_index do |pay_report, index|
      # ------code comes here

      @logger.info "Payment report :: #{index + 1}. #{pay_report.inspect}"
      if @fund_movements.first
        if index == 0
          @fund_movements.each_with_index do |fund_movement, index1|
            @logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
            if fund_movement.date.to_date < pay_report.date.to_date
              date = fund_movement.date
              narration = fund_movement.narration
              debit_amt = fund_movement.amt
              credit_amt = ""
              data << [date, narration, debit_amt, credit_amt]
            end
          end
        else
          @fund_movements.each_with_index do |fund_movement, index1|
            @logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
            if fund_movement.date.to_date <= pay_report.date.to_date && fund_movement.date.to_date >= @financial_statement[index - 1].date.to_date
              date = fund_movement.date
              narration = fund_movement.narration
              debit_amt = fund_movement.amt
              credit_amt = ""
              data << [date, narration, debit_amt, credit_amt]
            end
          end
        end
      end
      
      date = pay_report.date
      narration = "Collections for #{pay_report.date.to_date.strftime("%B %d, %Y")}"
      debit_amt = ""
      credit_amt = pay_report.actual_amt
      data << [date, narration, debit_amt, credit_amt]
    end
    data
  end





end













