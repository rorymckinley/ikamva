require 'fastercsv'

class Upload
  def self.import_branches(content)
    FasterCSV.parse(content) do |branch_record|
      Branch.create! :name => branch_record[0]
    end
  end
  def self.import_combined(content)
    Time.zone = 'Pretoria'
    FasterCSV.parse(content, :headers => true) do |combined_record|
      branch = Branch.find_by_name(combined_record[0].strip) || Branch.create!(:name => combined_record[0].strip)
      combined_record.each do |key,value|
        if key=~ /\d{4}\/\d{2}\/\d{2}/ && value && !branch.events.find_by_grade_and_start(combined_record["Grade"], Time.parse(key) + 2.hours)
          branch.events.create! :grade => combined_record["Grade"], :start => Time.parse(key) + 2.hours, :end => Time.parse(key) + 4.hours
        end
      end
      branch.members.create :first_name => combined_record["First Name"], :surname => combined_record["Surname"]
    end
  end
end
