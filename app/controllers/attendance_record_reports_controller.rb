class AttendanceRecordReportsController < ApplicationController
  def new
    @branches = Branch.all
  end
  def index
    @report_result = AttendanceRecordReport.generate(params[:branch_id])
    send_data render_to_string(:layout => false), :filename => @report_result[:report_name] + ".csv", :type => "text/csv"
  end
end
