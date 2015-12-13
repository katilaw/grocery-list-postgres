require "spec_helper"

feature "user views grocery list" do
  scenario "sees grocery items" do
    db_connection do |conn|
      sql_query = "INSERT INTO groceries (name) VALUES ($1)"
      data = ["eggs"]
      conn.exec_params(sql_query, data)
    end

    visit "/groceries"
    expect(page).to have_content("eggs")
  end
end
