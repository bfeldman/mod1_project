module MovieMethod
    
    def list
        List.all.find_by(user_id: @session_user.id)
    end

    def list_movies
        puts "~~~~" + self.list.name + "~~~~"
        @session_user.movies.each_with_index {|movie, i| puts "#{i + 1}. #{movie.title}"}
        self.main_menu
    end
    
    def highest_rated
        @session_user.highest_rated.each_with_index {|movie, i| puts "#{i + 1}. #{movie.title} (Metascore: #{movie.metascore})"}
        self.main_menu
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