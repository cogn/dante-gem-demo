#!/usr/bin/env ruby

require 'rubygems'
require 'dante'
require 'roo'

ENV["RAILS_ENV"] ||= "development"

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config", "environment"))

$running = true
Signal.trap("TERM") do 
  $running = false
end


@pid = '/tmp/dante.pid'
@log_path = '/tmp/dante.log'

# this method will logs the products count by category-wise for every minute
def products_count
    logger = Logger.new('products_count.log')
    logger.info "This daemon is started at #{Time.now}.\n"
    loop{
        p_count = Product.count(:all, :group => :category)
        logger.info " ----- Product Category Count ----"
        p_count.each do |name, count|
          logger.info "#{name}: #{count}"        
        end
        sleep 60
    }
end

case ARGV[0]
when 'start'
  Dante::Runner.new('products_count').execute(:daemonize => true, :pid_path => @pid, :log_path => @log_path) { 
    products_count
  }
when 'stop'
  Dante::Runner.new('products_count').execute(:kill => true, :pid_path => @pid)
when 'restart'
  Dante::Runner.new('products_count').execute(:daemonize => true, :restart => true, :pid_path => @pid) {   
    products_count
  }
else
  puts "Enter valid params"
end

