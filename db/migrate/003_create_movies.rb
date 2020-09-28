class CreateMovies < ActiveRecord::Migration[5.1]
    def change
        create_table :movies do |t|
            t.string :title
            t.string :cast
            t.string :plot
            t.integer :year
            t.integer :metascore
            t.string :imdb_id
        end
    end
end