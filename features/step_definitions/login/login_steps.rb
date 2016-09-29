Given(/^I visit the Redbridge Council homepage$/) do
  visit "https://v3test.redbridge.gov.uk/"
end

Given(/^I logged in to the Redbridge Council site$/) do
  @login_page = LoginPage.new
  @login_page.load
  @login_page.username.set "Automation"
  @login_page.password.set "Test1234"
  @login_page.login_button.click
  wait_for_an_element_to_appear
end

Given(/^I am logged in as a user to the Redbridge Council site$/) do
  @login_page = LoginPage.new
  @login_page.load
  @login_page.username.set "imranf2"
  @login_page.password.set "Test1234"
  @login_page.login_button.click
  wait_for_an_element_to_appear
end