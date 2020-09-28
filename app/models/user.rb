class User < ActiveRecord::Base
  has_one :list
  has_many :movies, through: :lists_movies
  
  def full_name
    self.first_name + " " + self.last_name
  end
  
  def movies
    list = List.find { |list| list.user_id == self.id }
    lm = ListsMovies.all.find_all {|lm| list.id == lm.list_id}
    #binding.pry
    movies = []
    lm.each do |blob|
      Movie.all.each do |m|
        if m.id == blob.movie_id
          movies << m
        end
      end
    end
    movies
  end
  
  def highest_rated
    self.movies.sort_by{|movie| -movie.metascore}.take(3)
  end
  
end