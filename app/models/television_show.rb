class TelevisionShow
  attr_reader :title, :network, :starting_year, :genre, :synopsis, :errors

  GENRES = ["Action", "Mystery", "Drama", "Comedy", "Fantasy"]

  def initialize(title, network, starting_year, genre, synopsis, errors = [])
    @title = title
    @network = network
    @starting_year = starting_year
    @genre = genre
    @synopsis = synopsis
  end

  def self.all
    tv_shows = []
    CSV.foreach("television-shows.csv", headers: true) do |row|
      tv_shows << TelevisionShow.new(row[0], row[1], row[2], row[3], row[4])
    end
    tv_shows
  end

  def valid?
    valid = true
    CSV.foreach("television-shows.csv", headers: true) do |row|
      if row[0] == @title
        valid = false
      end
    end
    if @title == "" || @network == "" || @starting_year == "" || @genre == "" || @synopsis == ""
      valid = false
    end
    valid
  end
end
