require 'prawn'
require "date"
class FinancialStatementPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  # require 'active_record'
  # require 'active_support/core_ext'
  def initialize(financial_statement, fund_movements, balance_bf, closing_bal, debit_total, credit_total, div_name, start_date, end_date, logger, options = {}, &block)
    # super :page_size => "A4", :page_layout => :landscape
    super options
    # super(top_margin: 70)
    @financial_statement = financial_statement
    @logger = logger
    @fund_movements = fund_movements
    @balance_bf = balance_bf
    @div_name = div_name
    @start_date = start_date
    @end_date = end_date
    @closing_bal = closing_bal
    @debit_total = debit_total
    @credit_total = credit_total
    # header
    header_info
    # body
    to_pdf
    # footer
    footer_paging
  end



  def header_info
    image "public/images/anm_logo.png", :scale => 0.2, :width => 150, :position => 600
    text "<b>FINANCIAL STATEMENT</b>", :align => :center, :size => 14, :inline_format => true
    move_down 10
    y_position = cursor
    bounding_box([0, y_position], :width => 450) do
      text "<b>Name Of Service</b><color rgb='ffffff'>_____</color>: #{@div_name}", :inline_format => true
      move_down 10
      text "<b>Financial Currency</b><color rgb='ffffff'>__...</color>: GHS", :inline_format => true
      move_down 10
      text "<b>Period</b><color rgb='ffffff'>______________</color>: #{@start_date.to_date.strftime("%B %d, %Y")} To #{@end_date.to_date.strftime("%B %d, %Y")}", :inline_format => true
      move_down 10
      text "<b>Date/Time Generated</b><color rgb='ffffff'>_.</color>: #{DateTime.now.strftime("%B %d, %Y %I:%M %p")}", :inline_format => true
      transparent(0) { stroke_bounds }
    end

    bounding_box([500, y_position], :width => 300) do
      text "<b>Opening Balance</b><color rgb='ffffff'>___</color>: #{number_to_currency(@balance_bf, unit: "", precision: 2)}", :inline_format => true
      move_down 10
      text "<b>Total Debit</b><color rgb='ffffff'>________.</color>: #{number_to_currency(@debit_total, unit: "", precision: 2)}", :inline_format => true
      move_down 10
      text "<b>Total Credit</b><color rgb='ffffff'>________</color>: #{number_to_currency(@credit_total, unit: "", precision: 2)}", :inline_format => true
      move_down 10
      text "<b>Closing Balance</b><color rgb='ffffff'>____</color>: #{number_to_currency(@closing_bal, unit: "", precision: 2)}", :inline_format => true
      transparent(0) { stroke_bounds }
    end

    move_down 30
  end




  def to_pdf
    @logger.info "Table data is #{pdf_records.inspect}"

    table pdf_records do
      self.cell_style = { size: 12 }
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.width = 760
      self.cells.border_width = [1,0,1,0]
      # self.column_widths = [40, 300, 200]
    end

  end



  def footer_paging
    repeat :all do
      # header
      canvas do
        bounding_box([bounds.left, bounds.top], :width => bounds.width) do
          cell :content => 'Header',
               :background_color => 'FFFFFF',
               :width => bounds.width,
               :height => 1,
               :align => :center,
               :text_color => "FFFFFF",
               :borders => [:bottom],
               :border_width => 2,
               :border_color => 'FFFFFF',
               :padding => 5
        end
      end
      # footer
      canvas do
        bounding_box [bounds.left, bounds.bottom + 60], :width  => bounds.width do
          cell :content => 'This is a computer generated printout & does not need signature. In case of discrepancies, please contact appsNmobile at the earliest.',
               :background_color => 'FFFFFF',
               :width => bounds.width,
               :height => 33,
               :align => :center,
               :text_color => "000000",
               :borders => [:top, :bottom],
               :border_width => 1,
               :padding => 11
        end
      end
    end
    number_pages "Page <page> of <total>", { :start_count_at => 1, :page_filter => :all, :at => [0, bounds.bottom - 50], :align => :right, :size => 10, :height => 10 }
  end



  def pdf_records

    data = [['Date', 'Description', 'Debit', 'Credit', 'Balance']]
    balance = @balance_bf
    if @financial_statement.first
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
                balance = balance - debit_amt
                data << [date, narration, number_to_currency(debit_amt, unit: "", precision: 2), credit_amt, number_to_currency(balance, unit: "", precision: 2)]
              end
            end
          else
            @fund_movements.each_with_index do |fund_movement, index1|
              @logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
              if fund_movement.date.to_date < pay_report.date.to_date && fund_movement.date.to_date >= @financial_statement[index - 1].date.to_date
                date = fund_movement.date
                narration = fund_movement.narration
                debit_amt = fund_movement.amt
                credit_amt = ""
                balance = balance - debit_amt
                data << [date, narration, number_to_currency(debit_amt, unit: "", precision: 2), credit_amt, number_to_currency(balance, unit: "", precision: 2)]
              end
            end
          end
        end

        date = pay_report.date
        narration = "Collections for #{pay_report.date.to_date.strftime("%B %d, %Y")}"
        debit_amt = ""
        credit_amt = pay_report.actual_amt
        balance = balance + credit_amt
        data << [date, narration, debit_amt, number_to_currency(credit_amt, unit: "", precision: 2), number_to_currency(balance, unit: "", precision: 2)]

        if @fund_movements.first
          @fund_movements.each_with_index do |fund_movement, index1|
            @logger.info "Fund Movement report :: #{index1 + 1}. of #{index + 1}. #{fund_movement.inspect}"
            if @financial_statement.size.to_i == index + 1 && fund_movement.date.to_date >= pay_report.date.to_date
              date = fund_movement.date
              narration = fund_movement.narration
              debit_amt = fund_movement.amt
              credit_amt = ""
              balance = balance - debit_amt
              data << [date, narration, number_to_currency(debit_amt, unit: "", precision: 2), credit_amt, number_to_currency(balance, unit: "", precision: 2)]
            end
          end
        end
      end
    else
      if @fund_movements.first
        @fund_movements.each_with_index do |fund_movement, index1|
          @logger.info "Fund Movement report :: #{index1 + 1}. #{fund_movement.inspect}"
          date = fund_movement.date
          narration = fund_movement.narration
          debit_amt = fund_movement.amt
          credit_amt = ""
          balance = balance - debit_amt
          data << [date, narration, number_to_currency(debit_amt, unit: "", precision: 2), credit_amt, number_to_currency(balance, unit: "", precision: 2)]
        end
      end
    end

    data
  end




end













