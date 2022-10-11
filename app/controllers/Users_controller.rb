class UsersController < ApplicationController
    def index
        Redis.current.flushall
        puts "~~~~~~~~~~~~~~ REDIS CLEARED EVERY THING ~~~~~~~~~~~~~~~~~~"
        #session.destroy
    end
end
