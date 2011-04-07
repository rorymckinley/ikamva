require 'spec_helper'

describe AttendanceRecordReportsController do
  render_views 

  before(:each) do
    authorised
    Branch.delete_all
    Branch.create! :name => "Branch One"
    Branch.create! :name => "Branch Two"
  end
  it "should provide a form that allows the selection of a branch to filter the attendance records" do
    get :new
    response.should be_ok
    response.should render_template("attendance_record_reports/new")
    assigns[:branches].should == Branch.all
  end
  it "should return the report details for a branch as a csv file" do
    report_output = { :report_name => Branch.first.name.gsub(/\s+/, '_').camelize + "AttendanceRecords", :report =>  [{ :first_name => "Fred", :surname => "Flintstone", :attendance_record => "green", :percentage_attendance => 75, :grade => 8 }]}
    AttendanceRecordReport.should_receive(:generate).with(Branch.first.id).and_return(report_output)

    get :index, :branch_id => Branch.first.id
    response.should be_ok
    response.content_type.should == 'text/csv'
    response.header["Content-Disposition"].should =~ /filename=\"#{report_output[:report_name] + ".csv"}\"/
    response.body.should == %Q{First Name,Surname,Grade,Attendance Record,Percentage Attendance
Fred,Flintstone,8,green,75

}
  end
end

