@pcn
@regression
Feature: As a Customer, I want to make a challenge against my PCN online
  So that I can easily challenge my PCN without having to visit the council
  or complete and send in a paper form

  Background:
	Given I visit the Redbridge Council homepage
	And I logged in to the Redbridge Council site

  @101 @69 @98 @informal_representation
  Scenario: make an Informal challenge against a PCN online
	Given I am viewing the PCN challenge Page
	And I have entered PCN and VRN numbers for the Informal Representation
	And a PCN status code allows a challenge to be made
	And I have selected to challenge a PCN
	And I have confirm the Terms and Conditions
	And I have selected challenge reasons
	And I provide a description
	And I confirm the information is correct for informal pcn
	When I submit the form
	Then I am taken to the Summary page with my details and reasons along with evidence

  @69 @127 @141 @formal_representation @non_registered_owner
  Scenario: make an Formal challenge against a PCN online as a non_registered owner of the vehicle
	Given I am viewing the PCN challenge Page
	And I have entered PCN and VRN numbers for the Formal Representation
	And a PCN status code allows a make a representation to the council
	And I have selected to log a PCN represntation using online form
	And I have confirm the Terms and Conditions
	And I am not a registered owner of the vehicle
	And I have a permission act on behalf of the owner of the vehicle
	And I attach proof of permission from the owner
	And I have selected a registered owner challenging a PCN
	And I provide a registered owner description
	When I confirm the information is correct
	Then I can submit a formal represntation form

  @69 @127 @141 @formal_represntation @registered_owner
  Scenario: make an Formal challenge against a PCN online as a registered owner of the vehicle
	Given I am viewing the PCN challenge Page
	And I have entered PCN and VRN numbers for the Formal Representation
	And a PCN status code allows a make a representation to the council
	And I have selected to log a PCN represntation using online form
	And I have confirm the Terms and Conditions
	And I am a registered owner of the vehicle
	And I navigate to the next stage
	And I have selected a registered owner challenging a PCN
	And I provide a registered owner description
	When I confirm the information is correct
	Then I can submit a formal represntation form

  @69 @501 @adjudicators
  Scenario: make an Adjudicators challenge against a PCN online as a registered owner of the vehicle
	Given I am viewing the PCN challenge Page
	When I have entered PCN and VRN numbers for the Adjudicators Representation
	Then I should get the appeal to the parking adjudicator status