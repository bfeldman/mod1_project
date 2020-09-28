class ListsMovies < ActiveRecord::Base
    has_many :movies
    has_many :lists
end