class AttendanceRecordReport
  def self.generate(branch_id)
    branch = Branch.find(branch_id)
    report_data = branch.members.inject([]) do |coll,member|
      event_count = (branch.events.find(:all, :conditions => {:grade => member.grade}).select { |e| e.start >= member.registration_date }).size
      percentage_attendance = ((member.attendance_total.to_f / event_count.to_f) * 100.0).round(0).to_i
      member_listing = {
        :first_name => member.first_name,
        :surname => member.surname,
        :grade => member.grade,
        :percentage_attendance => percentage_attendance,
        :attendance_record => calculate_attendance_record(percentage_attendance)
      }
      coll + [member_listing]
    end
    { :report => report_data, :report_name => branch.name.gsub(/\s+/, '_').camelize }
  end
  private
  def self.calculate_attendance_record(percentage)
    case percentage
    when 75..79
      "green"
    when 80..89
      "silver"
    when 90..99
      "gold"
    when 100
      "platinum"
    else 
      "red"
    end
  end
end
