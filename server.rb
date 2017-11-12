require 'sinatra'
require 'csv'
require 'pry'
require_relative "app/models/television_show"

set :bind, '0.0.0.0'  # bind to all interfaces
set :views, File.join(File.dirname(__FILE__), "app/views")

use Rack::Session::Cookie, {
  secret: "hello_i_am_a_frog",
  expire_after: 86400
}


get '/television_shows' do
  session[:tv_shows] = []
  CSV.foreach("television-shows.csv", headers: true) do |row|
    session[:tv_shows] << TelevisionShow.new(row[0], row[1], row[2], row[3], row[4])
  end
  erb :index
end

get '/television_shows/new' do
  erb :new
end

post "/create" do
  session[:errors] = []
  session[:new_show] = TelevisionShow.new(params[:title], params[:network], params[:starting_year], params[:genre], params[:synopsis])

  if session[:new_show].title == ""
    session[:errors] << "Title"
  end
  if session[:new_show].network == ""
    session[:errors] << "Network"
  end
  if session[:new_show].starting_year == ""
    session[:errors] << "Starting Year"
  end
  if session[:new_show].synopsis == ""
    session[:errors] << "Synopsis"
  end
  if session[:new_show].genre == ""
    session[:errors] << "Genre"
  end

  if !session[:errors].empty?
    session[:error_read] = true
    binding.pry
    @error_read = true
    redirect "/television_shows/new"
  elsif !session[:new_show].valid?
    session.clear
    session[:duplicate] = true
    redirect "television_shows"
  else
    CSV.open( 'television-shows.csv', 'at' ) do |csv|
      csv << [session[:new_show].title, session[:new_show].network, session[:new_show].starting_year, session[:new_show].synopsis, session[:new_show].genre].flatten
    end
      redirect "/television_shows"
  end
end
