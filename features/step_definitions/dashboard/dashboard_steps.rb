When(/^I visit the parking site$/) do
  @dashboard_page = DashboardPage.new
  @dashboard_page.load
  @dashboard_page.parking_link.click
end