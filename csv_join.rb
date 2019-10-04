#!/usr/bin/ruby -w

# csv_join: a join implementation for CSV files.
# Humam Rashid
# CISC 7510X, Fall 2019.

require 'csv'

def show_exit
  abort "Usage: #{$0} < -b | -m | -n > <file1> <file2>"
end

show_exit if ARGV.length != 1

def proc_args(opt)
  case opt
  when "-b"
    #puts "got b"
  when "-m"
    #puts "got m"
  when "-n"
    #puts "got n"
  else
    show_exit
  end
end

ARGV.each { |a| proc_args(a) }

# EOF.
