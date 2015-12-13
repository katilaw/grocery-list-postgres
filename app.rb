require "sinatra"
require "pg"
require "pry"

system ' psql grocery_list_development < schema.sql '

configure :development do
  set :db_config, { dbname: "grocery_list_development" }
end

configure :test do
  set :db_config, { dbname: "grocery_list_test" }
end

FILENAME = "grocery_list.txt"

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

@groceries = File.readlines(FILENAME)

@groceries.each do |item|
  clean_item = item.gsub!(/[\n]/,"")
  db_connection do |conn|
    conn.exec_params("INSERT INTO groceries (name) VALUES ($1)", [clean_item])
  end
end

get "/" do
  redirect "/groceries"
end

get "/groceries" do
  db_connection do |conn|
    @list = conn.exec("SELECT * FROM groceries;")
  end
  erb :groceries
end

post "/groceries" do
  db_connection do |conn|
    unless params[:name].strip.empty?
      sql_query = "INSERT INTO groceries (name) VALUES ($1)"
      data = params[:name]
      conn.exec_params(sql_query, [data])
    end
  end
  redirect "/groceries"
end

get "/groceries/:id" do
  db_connection do |conn|
    sql_query_1 = "SELECT groceries.*, comments.* FROM groceries LEFT JOIN comments ON groceries.id = comments.grocery_id WHERE groceries.id = ($1)"
    data = params["id"]
    @chosen_one = conn.exec(sql_query_1,[data])
  end
  erb :show
end

post "/groceries/:id" do
  redirect '/groceries'
end
