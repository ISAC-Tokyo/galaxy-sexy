# -*- coding: utf-8 -*-
require 'rubygems'
require 'rack'
require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'serialport'

configure do
    serial = "/dev/ttyACM0"
    set :sp, SerialPort.new(serial, 9600)
    set :public_folder, 'public'
    disable :protection
end

get '/brain' do
    # TODO JSON
    return "1335010152,200,0,0,83584,1017731,134968,212397,137195,349592,181972,1182824"
end

post '/brain' do
    puts request.body.read
end
