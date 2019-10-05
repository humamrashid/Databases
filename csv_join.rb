#!/usr/bin/ruby
# Humam Rashid
# CISC 7510X, Fall 2019.
#
# csv_join: A join implementation for CSV files.
# Assumes both CSV files have same number of fields per
# record and the join key at the same position in each
# record.
#
# CLI arguments:
#   1.) < -h | -m | -n >, for join implementation type
#   (hash, merge and nested respectively).
#
#   2.) <key_index>, for index of key to join records on,
#   (0 to number_of_fields - 1). Each key is assumed to be
#   unique to a record.
#
#   3.) <file1> <file2>, CSV files to join.

require 'csv'

def proc_arg(opt)
  case opt
  when "-h"
    return :hash
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

def hash_join(key_index, file1, file2)
  f1_htable = Hash.new
  file1.each { |i| f1_htable.store(i[key_index].hash, i) }
  file2.each do |j|
    f1_val = f1_htable[j[key_index].hash]
    puts "#{j[key_index]} #{f1_val.reject \
      {|e| e == j[key_index]}.to_csv.chomp} #{j.reject \
      { |e| e == j[key_index]}.to_csv.chomp}" \
      unless f1_val.nil?
  end
end

def merge_join(key_index, file1, file2)
end

def nested_join(key_index, file1, file2)
  for i in file1
    for j in file2
      if i[key_index] == j[key_index]
        puts "#{i[key_index]} "\
          "#{i.to_csv.chomp} "\
          "#{j.to_csv.chomp}"
      end
    end
  end
end

if ARGV.length != 4 or (choice = proc_arg(ARGV[0])).nil?
  msg = "Usage: #{$0} < -h | -m | -n > <key_index>"\
    " <file1> <file2>"
  abort msg
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
when :hash
  hash_join(key_index, file1, file2)
when :merge
  merge_join(key_index, file1, file2)
when :nested
  nested_join(key_index, file1, file2)
end

# EOF.
