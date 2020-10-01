module Startup
    
    
    def welcome
        puts "Welcome to The Movie App!"
        prompt = TTY::Prompt.new
        startup_choice = prompt.select("Do you want to...") do |menu|
            menu.choice 'Sign up', 1
            menu.choice 'Log in', 2
        end

        if startup_choice == 1
            self.signup
        elsif startup_choice == 2
            self.login
        end
    end
    
    def login
        prompt = TTY::Prompt.new
        username_input = prompt.ask("Username:")
        password_input = prompt.mask("Password:")
        
        @session_user = User.all.find_by(username: username_input, password: password_input)
        if @session_user == nil
            puts "User not found. Check your password! Check your spelling!"
            self.welcome
        else
            puts "Hello, #{@session_user.full_name}!"
            self.main_menu
        end
    end
    
    def signup
        prompt = TTY::Prompt.new
        first_name_input = prompt.ask("First name:")
        last_name_input = prompt.ask("Last name:")
        username_input = prompt.ask("Username:")
            while User.exists?(username: username_input)
                puts "Username already exists!"
                username_input = prompt.ask("Username:")
            end
        password_input = prompt.mask("Password:")
        
        @session_user = User.create(first_name: first_name_input, last_name: last_name_input, username: username_input, password: password_input)
        name_input = prompt.ask("What should we call your list?")
        List.create(user_id: @session_user.id, name: name_input)
        self.main_menu
    end

    def main_menu
        prompt = TTY::Prompt.new
        menu_choice = prompt.select("What would you like to do?") do |menu|
            menu.choice 'View my list of movies', 1
            menu.choice 'See my top 3 highest-rated movies', 2
            menu.choice 'See movies I have in common with other users', 3
            menu.choice 'Edit my list', 4
            menu.choice 'Look at movie posters', 5    
            menu.choice 'Look at movie trailers', 6        
        end

        if menu_choice == 1
            self.list_movies
        elsif menu_choice == 2
            self.display_highest_rated
        elsif menu_choice == 3
            self.shared_movies
        elsif menu_choice == 4
            self.edit_list
        elsif menu_choice == 5
            self.movie_posters
        elsif menu_choice == 6
            self.movie_trailers
        end
    end
    
end