module ListEdit
    

    def search_movies
        puts "What movie are you looking for?"
        search_term = gets.chomp
        api_query = RestClient.get("https://www.omdbapi.com/", {params: {apikey: 79068308, s: search_term}})
        result = JSON.parse(api_query)
        movies = result["Search"]
        
        puts "We found #{movies.length} results:"
        movies.each_with_index {|m,i| puts "#{i+1}. #{m['Title']} (#{m['Year']})"}

        puts "What movie would you like to add to your collection? (press a number)"
        input = gets.chomp
        input = input.to_i
        
        if input <= movies.length
            selection_id = movies[input - 1]["imdbID"]
            movie_query = RestClient.get("https://www.omdbapi.com/", {params: {apikey: 79068308, i: selection_id}})
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
    
    
end