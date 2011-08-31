#!/home/eric/.rvm/bin/ jruby-1.6.1@jasper_server

# encoding: utf-8

require 'rubygems'
require 'eventmachine'
require 'json'
require 'zlib'
require "base64"
require 'encryptor'
require 'java'

require 'digest/sha1'


require 'lib/report'

module ReportServer

  $CLASSPATH << "lib/fonts/"

  def receive_data data
  	begin
		  configs = JSON.parse(Zlib::Inflate.inflate(data))

		  report = Report.new(configs)
		  report_to_format = report.send("to_#{configs['formato']}")
		  
		  retorno = report_to_format
    rescue => e
    	retorno = "error:" + e.message
    end

    send_data Zlib::Deflate.deflate(retorno, 9)
    close_connection_after_writing
  end
end

EventMachine::run {
  EventMachine::start_server "127.0.0.1", 8081, ReportServer
  puts 'Reports Server running at port 8081'
}
