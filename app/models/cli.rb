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
        end
        
        if input == "2"
            self.login
        end
        
        #self.menu 
        #binding.pry 
    end
    
    def login
        puts "Username:"
        username_input = gets.chomp
        puts "Password:"
        password_input = gets.chomp
        
        @session_user = User.all.find_by(username: username_input, password: password_input)
        if @session_user == nil
            puts "User not found. Check you password!"
        else
            puts "Hello, #{@session_user.full_name}!"
        end
        self.welcome
        #binding.pry
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
        self.menu
        #binding.pry
    end

    def menu
        puts "Choose an option!"
        puts "1. View all films"
        puts "2. View all characters"
        choice = gets.chomp 
        
    end

    def search_songs
        puts "What song are you looking for?"
        search_term = gets.chomp
        # 1. RestClient.get("spotify.api/searchQuery")
        # 2. JSON.parse
        # 3. Let the user make some choices 
        # 4. Say they choose a favorite, make the updates to your 
        #     DB to save the song info you need easy access to and to represent the favorite 
    end

end