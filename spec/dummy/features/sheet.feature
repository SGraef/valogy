Feature: Validation Feedback
	
	Background: Preparing the Database
		Given The Ontology is successfully parsed

	Scenario: Try to add an not valid Sheet
		Given I'am on the create Sheets page
		When I will not generate a Slot
		And click on save
		Then I will see an validation Error
