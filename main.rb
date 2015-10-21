require 'pry-byebug'
require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pg'

before do
  @db =PG.connect(dbname: "todo", host: 'localhost')
end

after do
  @db.close
end

get '/' do
  redirect to('/items')
end

get '/items' do
  # Hint: Here's the line of code you would need to set a local variable 
  #       with a SQL string to get all the items from the DB, but what are
  #       you going to do with it?..
  #
  sql = "SELECT * FROM items"
  @items = run_sql(sql)
  erb :index
end

get '/items/new' do
  erb :new
end

post '/items' do
  item = params['item']
  details = params['details']

  sql = "insert into items (item, details) 
          values('#{item}', '#{details}')"
          run_sql(sql)

  # "insert into items...."
  redirect to('/items') # or can you get the id of the record created by the insert, and redirect to that?
end

get '/items/:id' do

  sql ="select * from items where id = #{params['id'].to_i}"

  @item = run_sql(sql).first
  erb :show
end

get '/items/:id/edit' do
  sql ="select * from items where id = #{params['id'].to_i}"

  @item = run_sql(sql).first
  erb :edit
end

post '/items/:id' do
  item = params[:item]
  details = params[:details]
  sql = "update items set item='#{item}', details='#{details}' where id='#{params[:id]}'"
  run_sql(sql)
  redirect to("/items/#{params[:id]}")
end

post '/items/:id/delete' do
  redirect to('/')
end
def run_sql(sql)
@db.exec(sql)
end