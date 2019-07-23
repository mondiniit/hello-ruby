#system 'clear'
require 'sinatra'
require 'yaml/store'
require 'logger'
require 'ougai'

class  App < Sinatra::Base
    file = StringIO.new
    #logger = Logger.new('/var/log/ruby.log') log plano
    logger = Ougai::Logger.new('/var/log/ruby.log') #log json
    Choices = {
        'HAM' => 'Hamburger',
        'PIZ' => 'Pizza',
        'CUR' => 'Curry',
        'NOO' => 'Noodles',
    }

    logger.info "hello world - ruby"

    get '/' do
        logger.info("hello from foo")
        erb :index
    end

    post '/cast' do
        logger.info("hello from cast")
        @title = 'Thanks for casting your vote!'
        @vote  = params['vote']
        @store = YAML::Store.new 'votes.yml'
        @store.transaction do
            @store['votes'] ||= {}
            @store['votes'][@vote] ||= 0
            @store['votes'][@vote] += 1
        end
        erb :cast
    end

    get '/results' do
        logger.info("hello from resuts")
        @title = 'Results so far:'
        @store = YAML::Store.new 'votes.yml'
        @votes = @store.transaction { @store['votes'] }
        erb :results
    end
    
end

#run App.run!