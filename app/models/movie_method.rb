module MovieMethod
    
    def list
        List.all.find_by(user_id: @session_user.id)
    end

    def list_movies
        puts "~~~~" + self.list.name + "~~~~"
        @session_user.movies.each_with_index {|movie, i| puts "#{i + 1}. #{movie.title}"}
        self.movie_metadata
    end
    
    def movie_metadata
        puts "Enter the number of a movie you want to know more about. (Type 'exit' to return to main menu.)"
        input = gets.chomp
        if input.to_i > @session_user.movies.size
            puts "Please enter a valid number."
            self.movie_menu
        elsif input.to_i <= @session_user.movies.size
            selection = @session_user.movies[input.to_i - 1]
            puts "#{selection.title.upcase} (#{selection.year})"
            puts "CAST:"
            puts selection.cast
            puts "PLOT:"
            puts selection.plot
            puts "METASCORE:"
            puts selection.metascore
            self.menu_loop
        elsif input.downcase == "exit"
            self.main_menu
        end
    end
    
    def menu_loop
        puts "====================="
        puts "Type 'movies' to bring up your list or 'exit' for the main menu."
        choice = gets.chomp
        if choice.downcase == "movies"
            self.list_movies
        elsif choice.downcase == "exit"
            self.main_menu
        else
            puts "Invalid option! Type 'movies' to bring up your list or 'exit' for the main menu."
        end
    end
    
    def highest_rated
        @session_user.highest_rated.each_with_index {|movie, i| puts "#{i + 1}. #{movie.title} (Metascore: #{movie.metascore})"}
        self.menu_loop
    end

    
    def shared_movies
        @session_user.movies.map do |m|
            movie_check = ListsMovies.movies_in_common(m.id)
            if movie_check != nil
                puts "Users who also like #{m.title.upcase}"
                movie_check.each do |user|
                    if user.full_name != @session_user.full_name
                        puts user.full_name
                    end
                end
            end
        end
        self.menu_loop
    end
    
end