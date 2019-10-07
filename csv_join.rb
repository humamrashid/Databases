#!/usr/bin/ruby
# Humam Rashid
# CISC 7510X, Fall 2019.
#
# csv_join: A join implementation for CSV files.
# Assumes both CSV files have same number of fields per
# record and the join key at the same position in each
# record. This implementation essentially follows a
# rudimentary version of the UNIX join utility specific to
# CSV files.
#
# CLI arguments:
#   1.) < -h | -m | -n >, for join implementation type
#   (hash, merge and nested-loop respectively).
#
#   2.) <key_index>, for index of key to join records on,
#   (0 to number_of_fields - 1). Each key is assumed to be
#   unique to a record in a table and each key is also
#   assumed to be 'comparable' so records can be sorted (for
#   merge joins).
#
#   3.) <file1> <file2>, CSV files to join.

require 'csv'

# Adding methods to String class to check if a String value
# is representing and integer or float.
class String
  def is_int?
    Integer(self) && true rescue false
  end
  def is_float?
    Float(self) && true rescue false
  end
end

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

# hash_join() puts all records of the first CSV file into a
# hashtable and compares against hashes of the join key for
# records in the second CSV file.
def hash_join(key_index, file1, file2)
  f1_htable = Hash.new
  file1.each do |i|
    f1_htable.store(i[key_index].hash, i) \
      unless i[key_index].nil?
  end
  file2.each do |j|
    f1_val = f1_htable[j[key_index].hash]
    puts "#{j[key_index]} #{f1_val.reject \
      { |e| e == j[key_index] }.to_csv.chomp} #{j.reject \
      { |e| e == j[key_index] }.to_csv.chomp}" \
      unless f1_val.nil?
      # Above checks to ensure that the join key is not
      # included as part of the output records in keeping
      # with the UNIX join utility's output.
  end
end

# merge_join() assumes join key is 'comparable' and treats
# the key as a string unless it represents a numeric type
# (int or float).
def merge_join(key_index, file1, file2)
  key = file1[0][key_index]
  if key.is_int?
    file1.sort_by! { |a| a[key_index].to_i }
    file2.sort_by! { |a| a[key_index].to_i }
  elsif key.is_float?
    file1.sort_by! { |a| a[key_index].to_f }
    file2.sort_by! { |a| a[key_index].to_f }
  else
    file1.sort_by! { |a| a[key_index] }
    file2.sort_by! { |a| a[key_index] }
  end

end

# nested_join() works ok for number of records upto the tens
# of thousands.
def nested_join(key_index, file1, file2)
  for i in file1
    for j in file2
      puts "#{i[key_index]} #{i.reject \
        { |e| e == i[key_index] }.to_csv.chomp} #{j.reject \
        { |e| e == i[key_index] }.to_csv.chomp}" \
        if (!i[key_index].nil? and !j[key_index].nil?) \
          and (i[key_index] == j[key_index])
      # Above checks to ensure that the join key is not
      # included as part of the output records in keeping
      # with the UNIX join utility's output.
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

if ARGV[1].is_int?
  key_index = ARGV[1].to_i
  if (key_index < 0) or (key_index >= file1[0].length)
    abort "Error: key_index out of bounds!"
  end
else
  abort "Error: key_index must be an integer value!"
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
