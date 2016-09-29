Given(/^I am viewing the PCN challenge Page$/) do
  @parking_page = ParkingPage.new
  @parking_page.load
  expect(@parking_page).to have_pcn_container
end

And(/^I have entered PCN and VRN numbers for the Informal Representation$/) do
  @parking_page.pcn.set "AF7200653"
  @parking_page.vrn.set "EG51DZT"
  @parking_page.submit_button.click
end

And(/^I have entered PCN and VRN numbers for the Formal Representation$/) do
  @parking_page.pcn.set "AF72000154"
  @parking_page.vrn.set "EG51DZT"
  @parking_page.submit_button.click
end
And(/^I have entered PCN and VRN numbers for the Adjudicators Representation$/) do
  @parking_page.pcn.set "AF90601633"
  @parking_page.vrn.set "EG51DZT"
  @parking_page.submit_button.click
end

Given(/^a PCN status code allows a challenge to be made$/) do
  wait_for_an_element_to_appear
  @parking_page.pcn_details.click
end

Given(/^I have selected to challenge a PCN$/) do
  expect(@parking_page).to have_challenge_penalty_charge_btn
  @parking_page.challenge_penalty_charge_btn.click
end

Given(/^I have confirm the Terms and Conditions$/) do
  wait_for_an_element_to_appear
  expect(@parking_page).to have_terms_and_cond_checkbox
  @parking_page.terms_and_cond_checkbox.click
end

Given(/^I have selected challenge reasons$/) do
  wait_for_an_element_to_appear
  @parking_page.challenge_reason_radiobox.click
end

Given(/^I provide a description$/) do
  expect(@parking_page).to have_challenge_reason_description
  @parking_page.challenge_reason_description.set "Testing in Progress"
end

Given(/^I confirm the information is correct$/) do
  @parking_page.confirmation_checkbox.click
  @parking_page.summarize_next_btn.click
end

When(/^I submit the form$/) do
  wait_for_an_element_to_appear
  @parking_page.should have_submit_challenge_btn
end

Then(/^I am taken to the Summary page with my details and reasons along with evidence$/) do
  @parking_page.should have_review_challenge
end

And(/^a PCN status code allows a make a representation to the council$/) do
  wait_for_an_element_to_appear
  @parking_page.pcn_challenge.click
end

And(/^I have selected to log a PCN represntation using online form$/) do
  wait_for_an_element_to_appear
  @parking_page.log_represntation_btn.click
end

And(/^I am not a registered owner of the vehicle$/) do
  wait_for_an_element_to_appear
  @parking_page.no_registered_owner.click
end

And(/^I am a registered owner of the vehicle$/) do
  wait_for_an_element_to_appear
  @parking_page.yes_registered_owner.click
end

And(/^I have a permission act on behalf of the owner of the vehicle$/) do
  wait_for_an_element_to_appear
  @parking_page.yes_permission.click
end

And(/^I attach proof of permission from the owner$/) do
  wait_for_an_element_to_appear
  sleep 3
  attach_file(@parking_page.proof_of_permission, "/assets/reason.jpg")
  sleep 2
  @parking_page.challenge_area_next_btn.click
end

And(/^I navigate to the next stage$/) do
  wait_for_an_element_to_appear
  @parking_page.goto_rep_reason_next_btn.click
  sleep 2
end

And(/^I have selected a registered owner challenging a PCN$/) do
  wait_for_an_element_to_appear
  @parking_page.registered_owner_challenge_reason.click
end

And(/^I provide a registered owner description$/) do
  wait_for_an_element_to_appear
  expect(@parking_page).to have_registered_owner_description
  @parking_page.registered_owner_description.set "Testing in Progress"
end

Then(/^I can submit a formal represntation form$/) do
  wait_for_an_element_to_appear
  expect(@parking_page).to have_formal_represntation_submit_btn
end

Then(/^I should get the appeal to the parking adjudicator status$/) do
  wait_for_an_element_to_appear
  find("a", :text => "Make an appeal to the parking adjudicator")
end

And(/^I confirm the information is correct for informal pcn$/) do
  @parking_page.confirmation_checkbox.click
  @parking_page.next_btn.click
end
