module ListEdit
    
    def edit_list
        prompt = TTY::Prompt.new
        menu_choice = prompt.select("What would you like to do?") do |menu|
            menu.choice 'Add movies to my list', 1
            menu.choice 'Delete movies from my list', 2
            menu.choice 'Rename list', 3
            menu.choice 'Go back to main menu', 4
        end
        
        if menu_choice == 1
            self.search_movies
        elsif menu_choice == 2
            self.delete_movies
        elsif menu_choice == 3
            self.rename_list
        elsif menu_choice == 4
            self.main_menu
        end
    end

    def search_movies
        prompt = TTY::Prompt.new
        pastel = Pastel.new
        search_term = prompt.ask("What movie are you looking for?") #get user search term
        api_query = RestClient.get("https://www.omdbapi.com/", {params: {apikey: $apikey, s: search_term}}) #query api
        result = JSON.parse(api_query) #parse JSON
        movies = result["Search"] #search results as a hash
        
        if movies == nil
            puts pastel.red("No results found!")
            self.edit_list
        end
        
        #creates menu choices
        movie_choice_hash = movies.each_with_object({}) do |m, hash|
            hash["#{m['Title']} (#{m['Year']})"] = m['imdbID']
        end
        movie_choice_hash["=GO BACK="] = 'bye'
        
        #displays menu choices
        movie_choice = prompt.select("What movie would you like to add to your collection?", movie_choice_hash, per_page: 11)
        if movie_choice == 'bye'
            self.edit_list
        end
        
        # grabs title metadata from API and adds to database and user's list
        selection_id = movie_choice
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
            film.poster = movie_to_add["Poster"]
        end
        
        ListsMovies.find_or_create_by(movie_id: new_movie.id, list_id: self.list.id)
        self.main_menu
    end

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
        
        if movie_to_delete_id == 'bye'
            self.edit_list
        end
        
        ListsMovies.where(list_id: @session_user.list.id, movie_id: movie_to_delete_id).destroy_all        
        self.main_menu
    end
    
    def rename_list
        prompt = TTY::Prompt.new
        new_name = prompt.ask("New list name:")
        
        list = List.find_by(user_id: @session_user.id)
        list.name = new_name
        list.save
        
        self.main_menu
    end
    
    
end