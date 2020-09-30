module MovieMethod
    
    def list
        List.all.find_by(user_id: @session_user.id)
    end

    def list_movies
        pastel = Pastel.new
        puts "~~~~" + pastel.red.on_cyan.bold(self.list.name) + "~~~~"
        user_movies = @session_user.movies
        prompt = TTY::Prompt.new
        movie_to_inspect = prompt.select("What movie do you want to know more about?") do |menu|
            menu.per_page 20
            user_movies.each do |m|
                menu.choice m.title, m.id
            end
            menu.choice '=Exit Menu=', 'bye'
        end
                
        if movie_to_inspect == 'bye'
            self.main_menu
        else
            self.movie_metadata(movie_to_inspect)
        end
    end
    
    def movie_metadata(movie_id)
        self.clear_screen
        pastel = Pastel.new
        selection = Movie.all.find_by(id: movie_id)
        puts pastel.red.on_white.bold("#{selection.title.upcase} (#{selection.year})")
        puts pastel.green("Cast:")
        puts selection.cast
        puts pastel.green("Director:")
        puts selection.director
        puts pastel.green("Plot:")
        puts selection.plot
        puts pastel.green("Metascore:")
        puts selection.metascore
        self.list_movies
    end
    
    def display_highest_rated
        self.clear_screen
        pastel = Pastel.new
        @session_user.highest_rated.each_with_index {|movie, i| puts pastel.red("#{i + 1}. ") + "#{movie.title} " + pastel.yellow("(Metascore: #{movie.metascore})") }
        self.main_menu
    end

    
    def shared_movies
        self.clear_screen
        pastel = Pastel.new
        @session_user.movies.map do |m|
            movie_check = ListsMovies.movies_in_common(m.id)
            if movie_check != nil
                puts "Users who also like " + pastel.red.bold(m.title.upcase)
                movie_check.each do |user|
                    if user.full_name != @session_user.full_name
                        puts user.full_name
                    end
                end
                puts "======================================"
            else
                puts "You have no movies in common with other users!"
            end
        end
        self.main_menu
    end
    
end