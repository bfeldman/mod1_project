module ListEdit
    
    def edit_list
        prompt = TTY::Prompt.new
        menu_choice = prompt.select("What would you like to do?") do |menu|
            menu.choice 'Add movies to my list', 1
            menu.choice 'Delete movies from my list', 2
            menu.choice 'Go back to main menu', 3
        end
        
        if menu_choice == 1
            self.search_movies
        elsif menu_choice == 2
            self.delete_movies
        elsif menu_choice == 3
            self.main_menu
        end
    end

    def search_movies
        prompt = TTY::Prompt.new
        search_term = prompt.ask("What movie are you looking for?")
        api_query = RestClient.get("https://www.omdbapi.com/", {params: {apikey: $apikey, s: search_term}})
        result = JSON.parse(api_query)
        movies = result["Search"]
        
        movie_choice = prompt.select("What movie would you like to add to your collection?") do |menu|
            menu.per_page 11
            movies.each_with_index do |m,i|
                menu.choice "#{m['Title']} (#{m['Year']})", i
            end
            menu.choice '=Go Back=', 'bye'
        end
        
        if movie_choice == 'bye'
            self.edit_list
        end
        
        
        selection_id = movies[movie_choice]["imdbID"]
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

        self.main_menu
    end

    # can be more DRY here if we can call self.list_movies from movie_method.rb, but list_movies currently goes back to main menu
    def delete_movies
        user_movies = @session_user.movies
        prompt = TTY::Prompt.new
        movie_to_delete_id = prompt.select("What movie would you like to delete from your collection?") do |menu|
            menu.per_page 20
            user_movies.each do |m|
                menu.choice m.title, m.id
            end
            menu.choice '=Exit Menu=', 'bye'
        end
        
        if movie_choice == 'bye'
            self.edit_list
        end
        
        ListsMovies.where(list_id: @session_user.list.id, movie_id: movie_to_delete_id).destroy_all        

        self.main_menu
    end
    
end