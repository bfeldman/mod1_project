class ListsMovies < ActiveRecord::Base
    has_many :movies
    has_many :lists
    
    def self.movies_in_common(movie)
        query = self.all.where(movie_id: movie)
        if query.length > 1
            query.map do |lm|
                list = List.all.find_by(id: lm.list_id)
                user = User.all.find_by(id: list.user_id)
            end
        end
    end
    
end