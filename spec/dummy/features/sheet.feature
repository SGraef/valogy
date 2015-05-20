Feature: Validation Feedback
	
	Background: Preparing the Database
		Given The Ontology is successfully parsed

	Scenario: Try to add an not valid Sheet
		Given I'm on the create Sheets page
		When I will not generate a Slot
		And click on Create Sheet
		Then I will see an validation Error

	Scenario: Try to add an valid Sheet
		Given I'm on the create Sheets page
		When I will generate a Slot
		And click on Create Sheet
		Then I will be on the Index page
		And The Sheet is created
