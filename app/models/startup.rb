module Startup
    
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
            self.welcome
        else
            puts "Hello, #{@session_user.full_name}!"
            self.main_menu
        end
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
        self.main_menu
    end

    def main_menu
        puts "What would you like to do? (enter a number or type 'exit' to log out)"
        puts "1. View my full list of movies"
        puts "2. Search for new movies to add to the list"
        puts "3. See my top 3 highest-rated movies"
        puts "4. See movies I have in common with other users"
        choice = gets.chomp
        if choice == "1"
            self.list_movies
        elsif choice == "2"
            self.search_movies
        elsif choice == "3"
            self.highest_rated
        elsif choice == "4"
            self.shared_movies
        elsif choice.downcase == "exit" || choice.downcase == "exit"
            :quit
        else
            puts "Invalid choice!"
            self.main_menu
        end
    end
end