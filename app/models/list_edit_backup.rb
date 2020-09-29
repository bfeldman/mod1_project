module ListEdit

    def search_movies
        puts "What movie are you looking for?"
        search_term = gets.chomp
        api_query = RestClient.get("https://www.omdbapi.com/", {params: {apikey: $apikey, s: search_term}})
        result = JSON.parse(api_query)
        movies = result["Search"]
        
        if movies == nil
            puts "Sorry, we couldn't find any movies with that name."
            self.main_menu

            
        else
            puts "We found #{movies.length} results:"

            movies.each_with_index {|m,i| puts "#{i+1}. #{m['Title']} (#{m['Year']})"}

            puts "What movie(s) would you like to add to your collection?\n(enter one or more numbers)"

            multiple_inputs
            input_check = @input.all? { |choice| choice.to_i <= movies.length }
            
            if input_check == true
                @input.each do |i|
                    @input = i.to_i
                    selection_id = movies[@input - 1]["imdbID"]
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
                        film.director = movie_to_add["Director"]
                    end
                    ListsMovies.find_or_create_by(movie_id: new_movie.id, list_id: self.list.id)
                end
            else
                puts "Invalid input!"
                movies.each_with_index {|m,i| puts "#{i+1}. #{m['Title']} (#{m['Year']})"}
            end

            self.main_menu

        end

        
    end

    # can be more DRY here if we can call self.list_movies from movie_method.rb, but list_movies currently goes back to main menu
    def delete_movies
        puts "What movie would you like to delete from your collection?"
        puts "~~~~" + self.list.name + "~~~~"
        #can add logic here to determine which list user wants to edit if we make users have more than one list
        movies = @session_user.movies.each_with_index {|movie, i| puts "#{i + 1}. #{movie.title}"}
        movies
        # input = gets.chomp

        multiple_inputs

        input_check = @input.all? { |choice| choice.to_i <= movies.length }
            
        if input_check == true
            @input.each do |i|
                movie_to_delete_id = @session_user.movies[@input - 1].id
                ListsMovies.where(list_id: @session_user.list.id, movie_id: movie_to_delete_id).destroy_all
            end
        else
            puts "Invalid input!"
        end

        self.main_menu

        # if input.to_i <= movies.length
        #     movie_to_delete_id = @session_user.movies[input - 1].id
        #     ListsMovies.where(list_id: @session_user.list.id, movie_id: movie_to_delete_id).destroy_all
        # else
        #     puts "Invalid input!"
        # end

        # self.main_menu
    end

    private

    def multiple_inputs
        @input = gets.chomp
        @input = @input.split(%r{\s*,\s*|\s*|\s*\.\s*}).uniq
    end
    
end