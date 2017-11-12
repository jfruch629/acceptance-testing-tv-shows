require "spec_helper"
# As a TV fanatic
# I want to view a list of my TV shows
# So I can keep track and share all my favorite shows
#
# Acceptance Criteria:
# [x] I can see the names and networks of all TV shows that have been added


feature "user views list of TV shows" do
  scenario "view list of TV shows" do
    #Add data to your CSV that your test depends on
    CSV.open('television-shows.csv', 'a') do |file|
      title = "Friends"
      network = "NBC"
      starting_year = "1994"
      synopsis = "Six friends living in New York city"
      genre = "Comedy"
      data = [title, network, starting_year, synopsis, genre]
      file.puts(data)
    end

    CSV.open('television-shows.csv', 'a') do |file|
      title = "Trailer Park Boys"
      network = "Netflix"
      starting_year = "2000"
      synopsis = "Shenanigans from Sunnyvale Trailer Park in Nova Scotia"
      genre = "Comedy"
      data = [title, network, starting_year, synopsis, genre]
      file.puts(data)
    end

    visit "/television_shows"

    expect(page).to have_content("Trailer Park Boys (Netflix)")
    expect(page).to have_content("Friends (NBC)")
  end
end
