#require 'prawn'
class ReportPdf < Prawn::Document
#  # require 'active_record'
#  # require 'active_support/core_ext'
#  def initialize(stock_monitors, params_season_id, logger, options = {}, &block)
#    # super :page_size => "A4", :page_layout => :landscape
#    super options
#    # super(top_margin: 70)
#    @stock_monitors = stock_monitors
#    @params_season_id = params_season_id
#    @logger = logger
#    # @perpage = perpage
#    # @page = page
#    # # @limit = limit
#    # # @offset = offset
#    to_pdf
#  end
#
#
#
#  # def self.to_pdf(perpage, page)
#  def to_pdf
#    @logger.info "Data :: #{pdf_records.inspect}"
#    table pdf_records do
#      self.cell_style = { size: 10 }
#      row(0).font_style = :bold
#      self.header = true
#      self.row_colors = ['DDDDDD', 'FFFFFF']
#      self.width = 760
#      # self.column_widths = [40, 300, 200]
#    end
#
#  end
#
#  # def self.pdf_records(perpage, page)
#  def pdf_records
#    # if @page == ""
#    #   page = 1
#    # else
#    #   page = @page.to_i
#    # end
#    # perpage= @perpage.to_i
#    #
#    # off = perpage*(page - 1)
#
#    # data = [['Full Name', 'Gender', 'Date of birth', 'Preferred Jobs', 'Qualification', 'Previous Job', 'Work Experience']]
#    # data = [['SOCIETIES','', 'SEEDFUND','','', 'EVACUATION TO DEPOT','','','', 'TOP UP(S)'], ['Name of PC', 'Mobile Number', 'DW', 'PW', 'Total', 'DW', 'PW', 'Total', 'Balance', 'Top Up']]
#
#    # data = [['Name of PC', 'Mobile Number', 'Seed DW', 'Seed PW', 'Total', 'Depot DW', 'Depot PW', 'Total', 'Balance', 'Top Up']]
#    # # data = [[['Name of PC', 'Mobile Number'], ['DW', 'PW', 'Total'], ['DW', 'PW', 'Total', 'Balance'], ['Top Up']]]
#    # # data += [[]] * page
#    # data +
#    #     @stock_monitors.map do |stock_monitor|
#    #       sdw,dw,pw,total = StockMonitor.seedfund(stock_monitor.pc_id, @params_season_id)
#    #       edw,epw,e_total = StockMonitor.evac_report(stock_monitor.pc_id, @params_season_id)
#    #       # number_to_currency(dw, unit: "")
#    #       balance = total - e_total
#    #       @logger.info "||||Seedfund Dw = #{dw}, pw = #{pw}, total = #{total}"
#    #       @logger.info "||||Evacuation Dw = #{edw}, pw = #{epw}, total = #{e_total}"
#    #       @logger.info "||||Balance :: #{balance.inspect}"
#    #       [stock_monitor.pc_name.to_s, stock_monitor.contact_no.to_s, dw.to_s, pw.to_s, total.to_s, edw.to_s, epw.to_s, e_total.to_s, balance.to_s, sdw.to_s]
#    #     end
#    #PC_Name Mobile_# Society Seedfund_DW TopUp_DW Seedfund_PW Seedfund_Total Depot_DW Bags_# Depot_PW Bags_# Depot_Total
#    data = [['Name of PC', 'Mobile Number', 'Society', 'Seed DW', 'Top Up', 'Seed PW', 'Total', 'Depot DW', 'Bags No.', 'Depot PW', 'Bags No.', 'Total']]
#
#    @stock_monitors.each do |summary|
#      sdw, dw, pw, total = StockMonitor.seedfund(summary.pc_id, @params_season_id)
#      during_wk_obj, prev_wk_obj, society_id_arr = StockMonitor.depot_report(summary.pc_id, @params_season_id)
#      @logger.info "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^pdf #{society_id_arr.inspect}"
#      @logger.info "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^pdf Previous #{prev_wk_obj.inspect}"
#      @logger.info "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^pdf During #{during_wk_obj.inspect}"
#      total = (total + sdw)
#
#      if society_id_arr.any?
#        society_id_arr.each do |society_id|
#          society_obj = RecipientGroup.where(id: society_id).first
#          society_name = society_obj ? society_obj.group_desc : "No Society"
#          dwk_amt = 0.0
#          pwk_amt = 0.0
#          db_num = 0.0
#          pb_num = 0.0
#          p_total = 0.0
#          dwk_size = during_wk_obj.size
#          pwk_size = prev_wk_obj.size
#          if during_wk_obj.any?
#            during_wk_obj.each_with_index do |dwk, index1|
#              if society_id == dwk.society_id.to_i || (dwk.society_id == nil && society_id.nil?)
#                @logger.info "MMMMMMMMMMMMMMMMMMpdf #{dwk.amount.to_f}"
#                @logger.info "NNNNNNNNNNNNNNNNNNpdf #{dwk.bag_number}"
#                dwk_amt = dwk.amount.to_f
#                db_num = dwk.bag_number
#                pwk_amt = 0.0
#                break
#              else
#                if dwk_size.to_i == index1 + 1
#                  dwk_amt = 0.0
#                  db_num = 0.0
#                end
#              end
#            end
#          else
#            dwk_amt = 0.0
#            db_num = 0.0
#          end
#          if prev_wk_obj.any?
#            prev_wk_obj.each_with_index do |pwk, index2|
#              if society_id == pwk.society_id.to_i || (pwk.society_id == nil && society_id.nil?)
#                pwk_amt = pwk.amount.to_f
#                pb_num = pwk.bag_number
#                p_total = dwk_amt + pwk_amt
#                break
#              else
#                if pwk_size.to_i == index2 + 1
#                  pwk_amt = 0.0
#                  pb_num = 0.0
#                  p_total = dwk_amt + pwk_amt
#                end
#              end
#            end
#          else
#            pwk_amt = 0.0
#            pb_num = 0.0
#            p_total = dwk_amt + pwk_amt
#          end
#
#          #PC_Name Mobile_# Society Seedfund_DW TopUp_DW Seedfund_PW Seedfund_Total Depot_DW Bags_# Depot_PW Bags_# Depot_Total
#          data << [summary.pc_name.to_s, summary.contact_no.to_s, society_name.to_s, dw.to_s, sdw.to_s, pw.to_s, total.to_s, dwk_amt.to_s, db_num.to_s, pwk_amt.to_s, pb_num.to_s, p_total.to_s]
#        end
#      else
#        data << [summary.pc_name.to_s, summary.contact_no.to_s, "", dw.to_s, sdw.to_s, pw.to_s, total.to_s, "0.0", "0.0", "0.0", "0.0", "0.0"]
#      end
#    end
#    data
#  end
#
#
end
#
#
#
#
#
#
#
#
#
#
#
#
#

