# -*- coding: utf-8 -*-
require 'rubygems'
require 'rack'
require 'sinatra'
require 'json'
require 'serialport'

configure do
    serial = "/dev/ttyACM0"
    set :sp, SerialPort.new(serial, 9600)
    set :public_folder, 'public'
    disable :protection
end

get '/brain' do
    # read brain data from db
    line = settings.sp.gets
    puts line
    return Time.now.to_i.to_s+','+line
end

post '/brain' do
    # write brain data from db
end
