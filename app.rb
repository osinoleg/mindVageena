# app.rb
require "sinatra"
require "sinatra/activerecord"
require 'json'
 
set :database, "sqlite3:mind.db"
set :environment, :production

# default 
mindOutPut = {"attention"=>50, "meditation"=>50}


helpers do
  # If @title is assigned, add it to the page's title.
  def title
    if @title
      "#{@title} -- MindVageena"
    else
      "MindVageena"
    end
  end
 
  # Format the Ruby Time object returned from a post's created_at method
  # into a string that looks like this: 06 Jan 2012
  def pretty_date(time)
   time.strftime("%d %b %Y")
  end

  def home_active?
    request.path_info == "/"
  end

  def about_active?
    request.path_info == "/about"
  end
  
end

# Get all of our routes
get "/" do
  @title = "Mind Graph"
  erb :"index"
end
 
# Our About Me page.
get "/about" do
  @title = "About Me"
  erb :"pages/about"
end

post "/mind_test" do
  puts "-----"
  puts mindOutPut

  mindOutPut = JSON.parse(request.body.read)
  puts mindOutPut
  puts mindOutPut["attention"]
  puts mindOutPut["meditation"]

  # settings.lol = mindOutPut
  # puts settings.lol

  # puts (JSON.parse(request.body.read))["meditation"]  
  # request.body.rewind
  # puts JSON.parse(request.body.read)
  # puts JSON.parse(request.body.read)["attention"]
  # puts JSON.parse(request.body.read)["meditation"]
  # @title = "About Me"
  # erb :"pages/about"
end

get "/poll_mind_data" do
  content_type 'application/json'
  mindOutPut.to_json
end
