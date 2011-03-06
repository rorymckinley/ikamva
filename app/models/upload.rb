require 'fastercsv'

class Upload
  def self.import_branches(content)
    FasterCSV.parse(content) do |branch_record|
      Branch.create! :name => branch_record[0]
    end
  end
  def self.import_combined(content)
    Time.zone = 'Pretoria'
    FasterCSV.parse(content) do |combined_record|
      branch = Branch.find_by_name(combined_record[0].strip) || Branch.create!(:name => combined_record[0].strip)
      branch.events.create! :purpose => combined_record[1], :start => Time.parse(combined_record[2]) + 2.hours, :end => Time.parse(combined_record[2]) + 4.hours, :grade => combined_record[3]
      branch.members.create :first_name => combined_record[4], :surname => combined_record[5]
    end
  end
end
