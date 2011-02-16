require 'fastercsv'

class Upload
  def self.import_branches(content)
    FasterCSV.parse(content) do |branch_record|
      Branch.create! :name => branch_record[0]
    end
  end
end
