require 'rest-client' 
require 'json'
require 'pry'

class CLI 

    def welcome
        puts "Welcome to The Movie App!"
        puts "Do you want to... (press a number)"
        puts "1. Sign up"
        puts "2. Log in"
        input = gets.chomp
        
        if input == "1"
            self.signup
        elsif input == "2"
            self.login
        end
    end
    
    def login
        puts "Username:"
        username_input = gets.chomp
        puts "Password:"
        password_input = gets.chomp
        
        @session_user = User.all.find_by(username: username_input, password: password_input)
        if @session_user == nil
            puts "User not found. Check you password! Check you capitalization!"
        else
            puts "Hello, #{@session_user.full_name}!"
        end
        self.menu
    end
    
    def signup
        puts "First name:"
        first_name_input = gets.chomp
        puts "Last name:"
        last_name_input = gets.chomp
        puts "Username:"
        username_input = gets.chomp
            while User.exists?(username: username_input)
                puts "User already exists!"
                puts "Username:"
                username_input = gets.chomp
            end
        puts "Password:"
        password_input = gets.chomp
        
        @session_user = User.create(first_name: first_name_input, last_name: last_name_input, username: username_input, password: password_input)
        puts "Name your list!"
        name_input = gets.chomp
        List.create(user_id: @session_user.id, name: name_input)
        self.menu
    end

    def menu
        puts "What would you like to do? (enter a number)"
        puts "1. View my list of movies"
        puts "2. Search for new movies"
        puts "3. See my top 3 highest-rated"
        puts "4. See movies I share with other users"
        choice = gets.chomp
        if choice == "1"
            self.list_movies
        elsif choice == "2"
            self.search_movies
        elsif choice == "3"
            self.highest_rated
        elsif choice == "4"
            self.shared_movies
        else
            puts "Invalid choice!"
            self.menu
        end
    end

    def list
        List.all.find_by(user_id: @session_user.id)
    end

    def list_movies
        puts "~~~~" + self.list.name + "~~~~"
        @session_user.movies.each_with_index {|movie, i| puts "#{i + 1}. #{movie.title}"}
        self.menu
    end
    
    def highest_rated
        @session_user.highest_rated.each_with_index {|movie, i| puts "#{i + 1}. #{movie.title} (Metascore: #{movie.metascore})"}
        self.menu
    end

    def search_movies
        puts "What movie are you looking for?"
        search_term = gets.chomp
        api_query = RestClient.get("https://www.omdbapi.com/", {params: {apikey: ?????, s: search_term}})
        result = JSON.parse(api_query)
        movies = result["Search"]
        
        puts "We found #{movies.length} results:"
        movies.each_with_index {|m,i| puts "#{i+1}. #{m['Title']} (#{m['Year']})"}

        puts "What movie would you like to add to your collection? (press a number)"
        input = gets.chomp
        input = input.to_i
        
        if input <= movies.length
            selection_id = movies[input - 1]["imdbID"]
            movie_query = RestClient.get("https://www.omdbapi.com/", {params: {apikey: ?????, i: selection_id}})
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

        self.menu
    end
    
    def shared_movies
        @session_user.movies.map do |m|
            movie_check = ListsMovies.movies_in_common(m.id)
            puts "Users who also like #{m.title.upcase}"
            if movie_check != nil
                movie_check.each {|user| puts user.full_name}
            else
                puts "You're the only person who likes this movie."
            end
        end
    end

end