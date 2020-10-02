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
            menu.choice '=Go back=', 'bye'
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
                puts "======================================"
                puts "Users who also like " + pastel.red.bold(m.title.upcase)
                movie_check.each do |user|
                    if user.full_name != @session_user.full_name
                        puts user.full_name
                    end
                end
            else
                puts "You have no movies in common with other users!"
            end
        end
        self.main_menu
    end

    def display_poster(selection)
        if selection.poster == 'N/A'
            puts "No movie posters found!"
        elsif
            app_check?("magick") == nil
            puts "Sorry, you need to install ImageMagick for this feature."
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
            menu.choice '=Go back=', 'bye'
        end
                
        if trailer_to_view == 'bye'
            self.main_menu
        else
            prompt = TTY::Prompt.new
            trailer_choice = prompt.select("Do you want to...") do |menu|
            menu.choice 'Open the trailer in your browser', 1
            menu.choice 'Watch the trailer in your terminal (beta)', 2
            end
        end

        if trailer_choice == 1
            self.play_trailer_in_browser(trailer_to_view)
        elsif trailer_choice == 2
            self.play_trailer_in_shell(trailer_to_view)
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
    end

    def play_trailer_in_browser(movie_id)
        movie_trailer_url = get_trailer_link(movie_id)
        Launchy.open(movie_trailer_url)
        self.main_menu
    end

    def play_trailer_in_shell(movie_id)
        pastel = Pastel.new
        movie_trailer_url = get_trailer_link(movie_id)
        ffmpeg_check = app_check?("ffmpeg")
        youtubedl_check = app_check?("youtube-dl")
        unless ffmpeg_check == nil || youtubedl_check == nil
            puts pastel.green("Trailer is loading...")
            full_url = `youtube-dl -f bestvideo -g #{movie_trailer_url}`
            system ("ffmpeg -hide_banner -loglevel warning -i '#{full_url}' -c:v rawvideo -pix_fmt rgb24 -window_size 160x50 -f caca -" )
        else
            puts pastel.red("Sorry, you need to install ffmpeg and youtube-dl for this feature.")
        end
        self.main_menu
    end

    private

    def app_check?(cmd)
        exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
          exts.each do |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable?(exe) && !File.directory?(exe)
          end
        end
        nil
    end

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