# -*- coding: utf-8 -*-
require 'rubygems'
require 'rack'
require 'sinatra'
require 'mongo'
require 'json'

# TODO read from config 
DB_NAME = 'galaxy_sexy_test'
TABLE_NAME = 'wave_test2'

# TODO read from config
KEYS = ['timeStamp',
    'userName',
    'quality',
    'attention',
    'meditation',
    'deltaWave',
    'thetaWave',
    'lowAlphaWave',
    'highAlphaWave',
    'lowBetaWave',
    'highBetaWave',
    'lowGammaWave',
    'midGummaWave']


configure do
    set :public_folder, 'public'
    disable :protection
end

get '/brain' do
    conn = Mongo::Connection.new('localhost', 27017, :pool_size => 10, :pool_timeout => 15)
    table = conn.db(DB_NAME)[TABLE_NAME]
    content_type 'text/plain', :charset => 'utf-8'
    wave = table.find_one({}, {:sort => ['timeStamp', 'descending']});
    wave.delete('_id')
    wave.to_json
end

post '/brain' do
    data = request.body.read
    puts data
    vals = data.split(',')

    unless KEYS.length == vals.length
        # TODO return appropriate status code
        return "require #{KEYS.length} data"
    end

    dic = {}
    KEYS.each_with_index{|key, i|
        val = vals[i].strip
        if val =~ /^\d+$/
            val = val.to_i
        end
        dic[key] = val
    }

    puts dic.to_s

    # insert to mongodb
    # TODO read db settinngs from config
    conn = Mongo::Connection.new('localhost', 27017, :pool_size => 10, :pool_timeout => 15)
    table = conn.db(DB_NAME)[TABLE_NAME]
    table.insert(dic)
    return "success"
end
