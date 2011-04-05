class AttendanceRecordReport
  def self.generate(branch_id)
    branch = Branch.find(branch_id)
    report_data = branch.members.inject([]) do |coll,member|
      event_count = branch.events.count(:conditions =>  ["grade = ? AND start >= ?", member.grade, member.registration_date.to_date ])
      member_listing = {
        :first_name => member.first_name,
        :surname => member.surname,
        :grade => member.grade,
        :percentage_attendance => (member.attendance_total.to_f / event_count.to_f)* 100.0,
        :attendance_record => calculate_attendance_record((member.attendance_total.to_f / event_count.to_f)*100.0)
      }
      coll + [member_listing]
    end
    { :report => report_data }
  end
  private
  def self.calculate_attendance_record(percentage)
    case percentage.to_i
    when 75..79
      "green"
    when 80..89
      "silver"
    when 90..99
      "gold"
    when 100
      "platinum"
    end
  end
end
