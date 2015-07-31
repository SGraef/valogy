Given(/^The Ontology is successfully parsed$/) do
  Valogy::Translator.parse("#{Rails.root}/spec/fixtures/test.owl")
end

Given(/^There is an User$/) do
  User.create!(username: "foobar", password: "12345", email: "foo@bar.de")
end

Given(/^I'm on the create Sheets page$/) do
	visit new_sheet_path
end

When(/^I will not generate a Slot$/) do
	uncheck 'sheet_generate_slots'
end

When(/^click on Create Sheet$/) do
	click_button "Create Sheet"
end

Then(/^I will see an validation Error$/) do
	expect(page).to have_content("error prohibited this sheet from being saved:")
end

When(/^I will generate a Slot$/) do
	page.check 'sheet_generate_slots'
end

Then(/^I will be on the Index page$/) do
	expect(page).to have_content("Sheet was successfully created.")
end

Then(/^The Sheet is created$/) do
	expect(Sheet.all.size).to eq(1)
end
