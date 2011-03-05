require 'fastercsv'

class Upload
  def self.import_branches(content)
    FasterCSV.parse(content) do |branch_record|
      Branch.create! :name => branch_record[0]
    end
  end
  def self.import_combined(content)
    FasterCSV.parse(content) do |combined_record|
      branch = Branch.find_by_name(combined_record[0].strip) || Branch.create!(:name => combined_record[0].strip)
      branch.events.create! :purpose => combined_record[1]
    end
  end
end
