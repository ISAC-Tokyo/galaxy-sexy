# -*- coding: utf-8 -*-
require 'rubygems'
require 'serialport'
#require 'httpclient'
require 'digest/md5'
require "net/http"
require "uri"

if ARGV.size >= 1
  serial = ARGV[0]
  puts serial
  url = ARGV[1]
  sp = SerialPort.new(serial, 9600)
else
  sp = nil
  puts "serial_client.rb /dev/ttyACM1 http://sushi.yuiseki.net/brain"
  exit
end

def post(body, url)
  begin
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port){|http|
      resp = http.post(uri.path, body)
    }
  rescue Errno:: ECONNREFUSED
    puts "error"
  end
end

while true do
  line = sp.gets
  puts line
  csv = Time.now.to_i.to_s+','+line
  post(csv, url)
end


