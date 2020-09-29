require 'rest-client' 
require 'json'
require 'pry'
require "tty-prompt"
require_relative "../models/apikey.rb"
require_relative "../models/startup.rb"
require_relative "../models/movie_method.rb"
require_relative "../models/list_edit.rb"

class CLI 

    include Startup
    include MovieMethod
    include ListEdit
    
end