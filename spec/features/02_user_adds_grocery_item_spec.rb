require "spec_helper"

feature "user add grocery item" do
  scenario "successfully add grocery item" do
    visit "/groceries"
    fill_in "Name", with: "Peanut Butter"
    click_button "Submit"

    expect(page).to have_content "Peanut Butter"
  end

  scenario "submit form without name" do
    visit "/groceries"
    click_button "Submit"

    expect(page).to_not have_css("li")
  end
end
