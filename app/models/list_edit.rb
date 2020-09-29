module ListEdit
    

    def search_movies
        puts "What movie are you looking for?"
        search_term = gets.chomp
        api_query = RestClient.get("https://www.omdbapi.com/", {params: {apikey: $apikey, s: search_term}})
        result = JSON.parse(api_query)
        movies = result["Search"]
        
        puts "We found #{movies.length} results:"
        movies.each_with_index {|m,i| puts "#{i+1}. #{m['Title']} (#{m['Year']})"}

        puts "What movie would you like to add to your collection? (press a number)"
        input = gets.chomp
        input = input.to_i
        
        if input <= movies.length
            selection_id = movies[input - 1]["imdbID"]
            movie_query = RestClient.get("https://www.omdbapi.com/", {params: {apikey: $apikey, i: selection_id}})
            movie_result = JSON.parse(movie_query)
            movie_to_add = movie_result
            
            new_movie = Movie.find_or_create_by(imdb_id: movie_to_add["imdbID"]) do |film|
                film.title = movie_to_add["Title"]
                film.cast = movie_to_add["Actors"]
                film.plot = movie_to_add["Plot"]
                film.year = movie_to_add["Year"]
                film.metascore = movie_to_add["Metascore"]
                film.imdb_id = movie_to_add["imdbID"]
            end
            ListsMovies.find_or_create_by(movie_id: new_movie.id, list_id: self.list.id)
        else
            puts "Invalid input!"
            movies.each_with_index {|m,i| puts "#{i+1}. #{m['Title']} (#{m['Year']})"}
        end

        self.main_menu
    end

    # can be more DRY here if we can call self.list_movies from movie_method.rb, but list_movies currently goes back to main menu
    def delete_movies
        puts "What movie would you like to delete from your collection?"
        puts "~~~~" + self.list.name + "~~~~"
        #can add logic here to determine which list user wants to edit if we make users have more than one list
        movies = @session_user.movies.each_with_index {|movie, i| puts "#{i + 1}. #{movie.title}"}
        puts movies
        input = gets.chomp
        input = input.to_i

        if input <= movies.length
            movie_to_delete_id = @session_user.movies[input - 1].id
            ListsMovies.where(list_id: @session_user.list.id, movie_id: movie_to_delete_id).destroy_all
        else
            puts "Invalid input!"
        end

        self.main_menu
    end
    
end