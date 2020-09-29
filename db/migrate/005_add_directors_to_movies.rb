class AddDirectorsToMovies < ActiveRecord::Migration[5.1]
    def change
        add_column :movies, :director, :string
    end
end