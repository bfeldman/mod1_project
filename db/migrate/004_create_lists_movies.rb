class CreateListsMovies < ActiveRecord::Migration[5.1]
    def change
        create_table :lists_movies do |t|
            t.integer :list_id
            t.integer :movie_id
        end
    end
end