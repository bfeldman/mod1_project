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
        pastel = Pastel.new
        selection = Movie.all.find_by(id: movie_id)
        self.display_poster(selection)
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
        pastel = Pastel.new
        @session_user.highest_rated.each_with_index {|movie, i| puts pastel.red("#{i + 1}. ") + "#{movie.title} " + pastel.yellow("(Metascore: #{movie.metascore})") }
        self.main_menu
    end

    
    def shared_movies
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

    def display_poster(selection)
        if selection.poster == nil
            puts "No movie posters found!"
        else
            puts "Here's the poster for #{selection.title}"
            poster_image = selection.poster
            poster_defaults(poster_image)
        end
    end

    def movie_trailers
        pastel = Pastel.new
        puts "~~~~" + pastel.red.on_cyan.bold(self.list.name) + "~~~~"
        user_movies = @session_user.movies
        prompt = TTY::Prompt.new
        trailer_to_view = prompt.select("What movie trailer do you want to see?") do |menu|
            menu.per_page 20
            user_movies.each do |m|
                menu.choice m.title, m.id
            end
            menu.choice '=Exit Menu=', 'bye'
        end
                
        if trailer_to_view == 'bye'
            self.main_menu
        else
            self.get_trailer_link(trailer_to_view)
        end
    end

    def get_trailer_link(movie_id)
        selection = Movie.all.find_by(id: movie_id)
        puts "Here's the trailer for #{selection.title}"
        imdb_id = selection.imdb_id
        api_query = RestClient.get "https://api.themoviedb.org/3/find/#{selection.imdb_id}", {params: {api_key: $moviedb_key, external_source: 'imdb_id'}} #query api
        result = JSON.parse(api_query) #parse JSON to get id
        movie_trailer_id = result["movie_results"][0]["id"] #get id from themoviedb.com
        api_query = RestClient.get "https://api.themoviedb.org/3/movie/#{movie_trailer_id}", {params: {api_key: $moviedb_key, append_to_response: 'videos'}}
        result = JSON.parse(api_query)#parse JSON to get list of trailers
        movie_trailer_url = "https://youtu.be/" + result["videos"]["results"][0]["key"]
        self.play_trailer(movie_trailer_url)
    end

    def play_trailer(movie_trailer_url)
        Launchy.open(movie_trailer_url)
        # full_url = `youtube-dl -f bestvideo -g #{movie_trailer_url}`
        # system ("ffmpeg -hide_banner -loglevel warning -i '#{full_url}' -c:v rawvideo -pix_fmt rgb24 -window_size 80x25 -f caca -" )
        self.main_menu
    end

    private

    def poster_defaults(poster_image)
        Catpix::print_image poster_image.to_s,
            :limit_x => 0.3,
            :limit_y => 0,
            :center_x => false,
            :center_y => true,
            :bg => "white",
            :bg_fill => false,
            :resolution => "auto"
    end

end