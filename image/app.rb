# -*- coding: utf-8 -*-
require 'rubygems'
require 'rack'
require 'sinatra'
require 'sinatra/reloader'
require 'json'

configure do
    disable :protection
    enable :static
    set :public_folder, 'public'
    set :root, File.expand_path("#{File.dirname(__FILE__)}/../public")
end

get '/' do
  File.new('public/index.html').readlines
end

get '/random' do
  def zerofill(n,digit)
    str=n.to_s
    return str if str.size >digit 
    while str.size < digit
      str="0"+ str
    end
    return str
  end
  int = Random.new.rand(1..15000).to_s
  str = zerofill(int, 5)
  send_file "public/jpeg/PIA#{str}.jpg",
      :type => 'image/jpeg',
      :disposition => 'inline'
end
