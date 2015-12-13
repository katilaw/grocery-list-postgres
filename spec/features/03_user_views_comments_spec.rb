require "spec_helper"
require "pry"
feature "user views comments" do
  scenario "see name of grocery on grocery item show page" do
    db_connection do |conn|
      sql_query_1 = "INSERT INTO groceries (name) VALUES ($1)"
      data_1 = ["eggs"]
      conn.exec_params(sql_query_1, data_1)
    end

    visit "/groceries"
    click_link "eggs"

    expect(page).to have_content("eggs")
  end

  scenario "see comments on grocery item show page" do
    db_connection do |conn|
      sql_query_1 = "INSERT INTO groceries (name) VALUES ($1)"
      data_1 = ["eggs"]
      conn.exec_params(sql_query_1, data_1)

      sql_query_2 = "SELECT * FROM groceries WHERE name = $1"
      data_2 = ["eggs"]
      grocery_id = conn.exec_params(sql_query_2, data_2).first["id"]

      sql_query_3 = "INSERT INTO comments (body, grocery_id) VALUES ($1, $2)"
      data_3 = ["make sure they are fresh", grocery_id]
      conn.exec_params(sql_query_3, data_3)
    end

    visit "/groceries"
    click_link "eggs"
    expect(page).to have_content("make sure they are fresh")
  end
end
