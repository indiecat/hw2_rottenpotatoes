class Movie < ActiveRecord::Base
    def Movie.get_all_ratings
    ratings = Array.new
    Movie.all.each do |mov|
      ratings << mov.rating
    end
    ratings.sort.uniq
  end
end
