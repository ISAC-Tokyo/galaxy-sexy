# -*- coding: utf-8 -*-
require 'rubygems'
require 'serialport'
require 'httpclient'
require 'digest/md5'

if ARGV.size >= 1
  serial = ARGV[0]
  puts serial
  sp = SerialPort.new(serial, 9600)
else
  sp = nil
  puts "serial_client.rb /dev/ttyACM1"
  exit
end

while true do
  line = sp.gets
  puts line
  csv = Time.now.to_i.to_s+','+line
  httpc = HTTPClient.new
  postdata = { "id" => Digest::MD5.hexdigest("hogehogehoge"), "data" => csv }
  begin
      response = httpc.post_content("http://sushi.yuiseki.net/brain", postdata)
      puts response
  rescue HTTPClient::BadResponseError
      puts "error"
  end
end
