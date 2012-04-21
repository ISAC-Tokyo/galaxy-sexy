# -*- coding: utf-8 -*-
require 'rubygems'
require 'rack'
require 'sinatra'
require 'mongo'
require 'json'

# TODO read from config 
DB_NAME = 'galaxy_sexy_test'
TABLE_NAME = 'wave_test'

configure do
    set :public_folder, 'public'
    disable :protection
end

get '/brain' do
    request.body.rewind
    data = request.body.read.to_s 
    data = request.inspect.to_s
    puts data
    return Time.now.to_i.to_s + data
end

post '/brain' do
    data = request.body.read
    puts data

    # TODO read from config
    keys = ['timeStamp',
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

    vals = data.split(',')

    unless keys.length == vals.length
        # TODO return appropriate status code
        return "require #{keys.length} data"
    end

    dic = {}
    keys.each_with_index{|key, i|
        dic[key] = vals[i]
    }

    puts dic.to_s

    # insert to mongodb
    # TODO read db settinngs from config
    conn = Mongo::Connection.new('localhost', 27017, :pool_size => 10, :pool_timeout => 15)
    table = conn.db(DB_NAME)[TABLE_NAME]
    table.insert(dic)
    return "sucess"
end
