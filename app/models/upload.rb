require 'fastercsv'

class Upload
  def self.import_branches(content)
    FasterCSV.parse(content) do |branch_record|
      Branch.create! :name => branch_record[0]
    end
  end
  def self.import_combined(content)
    Time.zone = 'Pretoria'
    start_counts = {
      :branches => Branch.count, 
      :members => Member.count,
      :events => Event.count, 
      :attendance_details => AttendanceDetail.count
    }
    @duplicates = []
    FasterCSV.parse(content, :headers => true) do |combined_record|
      branch = Branch.find_by_name(combined_record[0].strip) || Branch.create!(:name => combined_record[0].strip)

      member_parameters = { :first_name => combined_record["First Name"].strip, :surname => combined_record["Surname"].strip, :grade => combined_record["Grade"]}
      if branch.members.find(:first, :conditions => member_parameters)
        @duplicates << member_parameters.merge!({ :branch => branch.name })
        next
      else
        member_parameters.merge!({ :registration_date => combined_record["Registration Date"] || "#{Time.now.year}-01-01"})
        member = branch.members.create!(member_parameters.merge(:participation => "learner"))
      end

      combined_record.each do |key,value|
        if key=~ /\d{4}\/\d{2}\/\d{2}/ && value 
          event = find_or_create_event(branch, combined_record["Grade"], key) { branch.events }
          event.attendance_details.create! :member => member, :status => (value.to_i == 1 ? "full" : "partial") unless event.attendance_details.find_by_member_id(member.id)
        end
      end
    end
    (start_counts.merge!(start_counts) { |k,v1,v2| k.to_s.singularize.camelize.constantize.count - v1 }).merge!({:duplicates => @duplicates})
  end

  private

  def self.find_or_create_event(branch, grade, date_string)
    start = Time.parse(date_string) + 2.hours
    events = yield
    events.find_by_grade_and_start(grade, start) || events.create!(:grade => grade, :start => start, :end => start + 2.hours, :purpose => start.wday == 6 ? "tutorial" : "homework")
  end
end
