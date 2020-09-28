class List < ActiveRecord::Base
  belongs_to :user
  has_many :movies, through: :lists_movies
end