class AddAdditionalFieldsToMembers < ActiveRecord::Migration
  def self.up
    remove_column :members, :name
    add_column :members, :first_name, :string
    add_column :members, :surname, :string
    add_column :members, :gender, :string
    #add_column :members, :date_of_birth, :date
    add_column :members, :mobile_number, :string
    #add_column :members, :parent_guardian_number, :string
    #add_column :members, :disabilities, :boolean
    add_column :members, :address, :string
    #add_column :members, :school, :string
    #add_column :members, :grade, :string
    add_column :members, :email, :string
    add_column :members, :id_number, :string
    #add_column :members, :citizenship, :string
    #add_column :members, :parent_guardian_1_relationship, :string
    #add_column :members, :parent_guardian_2_relationship, :string
    #add_column :members, :parent_guardian_1_job, :string
    #add_column :members, :parent_guardian_2_job, :string
    #add_column :members, :subjects, :text
    #add_column :members, :ikamvanite_family_members, :text
  end

  def self.down
  end
end
