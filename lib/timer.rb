#!/usr/bin/env ruby

require 'rubygems'
require 'dante'
require 'private_pub'
require 'roo'

ENV["RAILS_ENV"] ||= "development"

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config", "environment"))

$running = true
Signal.trap("TERM") do 
  $running = false
end


@pid = '/tmp/dante.pid'
@log_path = '/tmp/dante.log'

def print_each_cat_count
    Rails.logger.info "This daemon is started at #{Time.now}.\n"
    loop{
        products = Product.count(:all, :group => :category_id)
        Rails.logger.info " ----- Product Category Count ----"
        products.each do |p|
          
        end
        sleep 10
    }
end

case ARGV[0]
when 'start'
  Dante::Runner.new('suppress').execute(:daemonize => true, :pid_path => @pid, :log_path => @log_path) { 
    print_each_cat_count
  }
when 'stop'
  Dante::Runner.new('suppress').execute(:kill => true, :pid_path => @pid)
when 'restart'
  Dante::Runner.new('suppress').execute(:daemonize => true, :restart => true, :pid_path => @pid) {   
    print_each_cat_count
  }
else
  puts "Enter valid params"
end

