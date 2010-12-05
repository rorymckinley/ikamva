require 'spec_helper'

describe "sessions/new.erb" do
  before(:all) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
  end

  it "should contain a form that will create a new session for the selected branch" do
    assign(:branch, @branch_1)
    assign(:types, [[ 'Type 1', 'type_1' ], [ 'Type 2', 'type_2']])
    assign(:dates, [['2010-01-01'], ['2010-01-02'], ['2010-01-03']])
    assign(:times, [['08:00'], ['09:00'], ['10:00']])
    assign(:durations, [['30 minutes', 30], ['1 hour', 60], ['4 hours', 240]])
    assign(:late_times, [['5 minutes', 5], ['15 minutes', 15], ['30 minutes', 30]])

    render
    rendered.should have_selector("form", :method => "post", :action => branch_sessions_path(@branch_1)) do |form|
      form.should have_selector("select", :name => "session[type]") do |select|
        select.should have_selector("option", :value => "type_1") do |opt|
          opt.should contain('Type 1')
        end
        select.should have_selector("option", :value => "type_2")
      end
      form.should have_selector("select", :name => "session[date]") do |select|
        select.should have_selector("option", :value => "2010-01-01") do |opt|
          opt.should contain("2010-01-01")
        end
        select.should have_selector("option", :value => "2010-01-03")
      end
      form.should have_selector("select", :name => "session[time]") do |select|
        select.should have_selector("option", :value => "08:00") do |opt|
          opt.should contain("08:00")
        end
        select.should have_selector("option", :value => "10:00")
      end
      form.should have_selector("select", :name => "session[duration]") do |select|
        select.should have_selector("option", :value => "30") do |opt|
          opt.should contain("30 minutes")
        end
        select.should have_selector("option", :value => "240")
      end
      form.should have_selector("select", :name => "session[late_after]") do |select|
        select.should have_selector("option", :value => "5") do |opt|
          opt.should contain("5 minutes")
        end
        select.should have_selector("option", :value => "30")
      end
      form.should have_selector("input", :type => 'submit', :value => 'Save')
    end
  end
end
