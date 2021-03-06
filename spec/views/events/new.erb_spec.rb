require 'spec_helper'

describe "events/new.erb" do
  before(:all) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
  end

  it "should contain a form that will create a new event for the selected branch" do
    assign(:branch, @branch_1)
    assign(:purposes, [{ 'type_1' => 'Type 1' }, { 'type_2' => 'Type 2' }])
    assign(:dates, [['2010-01-01'], ['2010-01-02'], ['2010-01-03']])
    assign(:times, [['08:00'], ['09:00'], ['10:00']])
    assign(:durations, [['30 minutes', 30], ['1 hour', 60], ['4 hours', 240]])
    assign(:late_times, [['5 minutes', 5], ['15 minutes', 15], ['30 minutes', 30]])

    render
    rendered.should have_selector("form", :method => "post", :action => branch_events_path(@branch_1)) do |form|
      form.should have_selector("select", :name => "event[purpose]") do |select|
        select.should have_selector("option", :value => "type_1") do |opt|
          opt.should contain('Type 1')
        end
        select.should have_selector("option", :value => "type_2")
      end
      form.should have_selector("select", :name => "event[grade]") do |select|
        select.should have_selector("option", :value => "8")
        select.should have_selector("option", :value => "9")
        select.should have_selector("option", :value => "10")
        select.should have_selector("option", :value => "11")
        select.should have_selector("option", :value => "12")
      end
      form.should have_selector("input", :type => 'submit', :value => 'Save')
    end
  end

  it "should provide a link to return to the events page" do
    assign(:branch, @branch_1)
    assign(:purposes, [{ 'type_1' => 'Type 1' }, { 'type_2' => 'Type 2' }])
    assign(:dates, [['2010-01-01'], ['2010-01-02'], ['2010-01-03']])
    assign(:times, [['08:00'], ['09:00'], ['10:00']])
    assign(:durations, [['30 minutes', 30], ['1 hour', 60], ['4 hours', 240]])
    assign(:late_times, [['5 minutes', 5], ['15 minutes', 15], ['30 minutes', 30]])

    render
    rendered.should have_selector("a", :href => branch_events_path(@branch_1)) do |events_link|
      events_link.should contain("Return to Events")
    end
  end
end
