#!/usr/bin/ruby
# Humam Rashid
# CISC 7510X, Fall 2019.
#
# csv_join: a join implementation for CSV files.
#
# CLI arguments:
#   1.) < -b | -m | -n >, for join implementation type
#   (btree, merge and nested respectively).
#
#   2.) <key_index>, for index of key to join on.
#
#   3.) <file1> <file2>, CSV files to join.
require 'csv'

def proc_arg(opt)
  case opt
  when "-b"
    return :btree
  when "-m"
    return :merge
  when "-n"
    return :nested
  else
    return nil
  end
end

def exit_if_empty(file)
  abort "Invalid join: #{file} is empty!" if file.empty?
end

def btree_join(key_index, file1, file2)
end

def merge_join(key_index, file1, file2)
end

def nested_join(key_index, file1, file2)
  for i in file1
    for j in file2
      if i[key_index] == j[key_index]
        puts "#{i[key_index]} #{i[1..i.length].to_csv} #{j[1..j.length].to_csv}"
      end
    end
  end
end

if ARGV.length != 4 or (choice = proc_arg(ARGV[0])).nil?
  abort "Usage: #{$0} < -b | -m | -n > <key_index> <file1> <file2>"
end

file1 = CSV.read(ARGV[2])
exit_if_empty(file1)
file2 = CSV.read(ARGV[3])
exit_if_empty(file2)

key_index = ARGV[1].to_i
if (key_index < 0) or (key_index >= file1[0].length)
  abort "Join key index is out of bounds!"
end

case choice
when :btree
  btree_join(key_index, file1, file2)
when :merge
  merge_join(key_index, file1, file2)
when :nested
  nested_join(key_index, file1, file2)
end

# EOF.
