require File.expand_path('../../test_helper', __FILE__)

class LinkedIssuesTest < ActionController::IntegrationTest
  include Capybara::DSL

  fixtures :projects,
           :users,
           :roles,
           :members,
           :issues

  def test_gantt_filters
    visit '/login'
    fill_in "Login", :with => 'admin'
    fill_in "Password", :with => 'admin'
    click_on "Login »"

    # Create filter
    visit '/projects/ecookbook/queries/new'
    fill_in 'Name', :with => "Issues' Filter"
    select 'Priority', :from => "Add filter"
    select 'Normal', :from => 'values_priority_id'
    click_on 'Save'

    # Go back to filter less issues
    visit '/projects/ecookbook/issues?set_filter=1'

    # Make sure Gantt link is present
    assert page.find('#sidebar').text.include?("Issues' Filter")
    assert page.find('#sidebar').text.include?("[Gantt]")
    click_link('[Gantt]')

    # Should filter Gantt
    assert page.find("#content").text.include?('Bug #7')
    assert_equal page.find("#content").text.include?('Bug #3'), false
  end

  def test_permissions_on_gantt_filters
    visit '/login'
    fill_in "Login", :with => 'admin'
    fill_in "Password", :with => 'admin'
    click_on "Login »"

    visit "/roles/edit/2"
    uncheck "View gantt chart"
    click_on "Save"

    visit '/logout'


    visit '/login'
    fill_in "Login", :with => 'jsmith'
    fill_in "Password", :with => 'jsmith'
    click_on "Login »"

    # Create filter
    visit '/projects/onlinestore/queries/new'
    fill_in 'Name', :with => "Issues' Filter"
    select 'Priority', :from => "Add filter"
    select 'Normal', :from => 'values_priority_id'
    click_on 'Save'

    # Go back to filter less issues
    visit '/projects/onlinestore/issues?set_filter=1'

    # Make sure Gantt link is not present if not permited
    assert page.find('#sidebar').text.include?("Issues' Filter")
    assert_equal page.find('#sidebar').text.include?('[Gantt]'), false
  end
end