# -*- coding: utf-8 -*-
require 'rubygems'
require 'serialport'
require 'httpclient'
require 'digest/md5'

if ARGV.size >= 1
  serial = ARGV[0]
  sp = SerialPort.new(serial, 9600)
else
  puts "serial_client.rb /dev/ttyACM1"
  exit
end

while true do
  line = settings.sp.gets
  csv = Time.now.to_i.to_s+','+line
  httpc = HTTPClient.new
  postdata = { "id" => Digest::MD5.hexdigest("hogehogehoge"), "data" => csv }
  response = httpc.post_content("http://gyazo.com/upload.cgi", postdata)
  puts response
end
