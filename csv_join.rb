#!/usr/bin/ruby
# Humam Rashid
# CISC 7510X, Fall 2019.
#
# csv_join: A join implementation for CSV files.
# Assumes both CSV files have same number of fields per
# record and the join key is at the same position in each
# record (if it exists). This implementation is essentially
# a rudimentary version of the UNIX join utility specific to
# CSV files. In keeping with the output of the UNIX join,
# the join key is printed on the leftmost column but not in
# the matched records.
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
# is representing an integer or float.
class String
  def int?
    Integer(self) && true rescue false
  end

  def float?
    Float(self) && true rescue false
  end
end

# Checks if a string field value is less than another
# according to type represented (string, int or float).
def less_than?(val1, val2)
  if val1.int?
    val1.to_i < val2.to_i
  elsif val1.float?
    val1.to_f < val2.to_f
  else
    val1 < val2
  end
end

# Checks if a string field value is greater than another
# according to type represented (string, int or float).
def greater_than?(val1, val2)
  if val1.int?
    val1.to_i > val2.to_i
  elsif val1.float?
    val1.to_f > val2.to_f
  else
    val1 > val2
  end
end

# Checks for valid CLI arguments for join type.
def proc_arg(opt)
  case opt
  when '-h'
    :hash
  when '-m'
    :merge
  when '-n'
    :nested
  else
    nil
  end
end

# Exits with error message if 'file' is empty.
def exit_if_empty(file)
  abort "Error: #{file} is empty!" if file.empty?
end

# hash_join() puts all records of the first CSV file into a
# hashtable and compares against hashes of the join key for
# records in the second CSV file. Output is not sorted on
# join key.
def hash_join(key_index, file1, file2)
  f1_htable = {}
  file1.each do |i|
    f1_htable.store(i[key_index].hash, i) unless i[key_index].nil?
  end
  file2.each do |j|
    f1_val = f1_htable[j[key_index].hash]
    puts "#{j[key_index]} #{f1_val.reject { |e| e == j[key_index] }.to_csv.chomp} #{j.reject \
      { |e| e == j[key_index] }.to_csv.chomp}" unless f1_val.nil?
  end
end

# merge_sorter(): sorts CSV files for merge_join() by
# sorting records in-place.
def merge_sorter(key_index, file1, file2)
  key = file1[0][key_index]
  if key.int?
    # Treat the key as an integer.
    file1.sort_by! { |a| a[key_index].to_i }
    file2.sort_by! { |a| a[key_index].to_i }
  elsif key.float?
    # Treat the key as a float.
    file1.sort_by! { |a| a[key_index].to_f }
    file2.sort_by! { |a| a[key_index].to_f }
  else
    # Sort them according to lexical order.
    file1.sort_by! { |a| a[key_index] }
    file2.sort_by! { |a| a[key_index] }
  end
end

# merge_join() assumes join key is 'comparable' and treats
# the key as a string unless it represents a numeric type
# (int or float). Output is sorted on join key.
def merge_join(key_index, file1, file2)
  # Sorting part.
  merge_sorter(key_index, file1, file2)
  # Merging part.
  r = file1[i = 0]
  q = file2[j = 0]
  while i != file1.length && j != file2.length
    if greater_than?(r[key_index], q[key_index])
      q = file2[j += 1]
    elsif less_than?(r[key_index], q[key_index])
      r = file1[i += 1]
    else
      # The records match on the join key.
      puts "#{r[key_index]} #{r.reject { |e| e == r[key_index] }.to_csv.chomp} #{q.reject \
        { |e| e == r[key_index] }.to_csv.chomp}" unless r[key_index].nil? || q[key_index].nil?
      t = file2[k = j + 1]
      # Check for further records that match with r on the
      # join key.
      while k != file2.length && r[key_index] == t[key_index]
        puts "#{r[key_index]} #{r.reject { |e| e == r[key_index] }.to_csv.chomp} #{t.reject \
          { |e| e == r[key_index] }.to_csv.chomp}" unless r[key_index].nil? || t[key_index].nil?
        t = file2[k += 1]
      end
      s = file1[l = i + 1]
      # Check for further records that match with q on the
      # join key.
      while l != file1.length && q[key_index] == s[key_index]
        puts "#{q[key_index]} #{q.reject { |e| e == q[key_index] }.to_csv.chomp} #{s.reject \
          { |e| e == q[key_index] }.to_csv.chomp}" unless q[key_index].nil? || s[key_index].nil?
        s = file1[l += 1]
      end
      r = file1[i += 1]
      q = file2[j += 1]
    end
  end
end

# nested_join() works ok for number of records upto the tens
# of thousands. Output is not sorted on join key.
def nested_join(key_index, file1, file2)
  for i in file1
    for j in file2
      puts "#{i[key_index]} #{i.reject { |e| e == i[key_index] }.to_csv.chomp} #{j.reject \
        { |e| e == i[key_index] }.to_csv.chomp}" if (!i[key_index].nil? && !j[key_index].nil?) && \
        (i[key_index] == j[key_index])
    end
  end
end

if ARGV.length != 4 || (choice = proc_arg(ARGV[0])).nil?
  msg = "Usage: #{$PROGRAM_NAME} < -h | -m | -n > <key_index> <file1> <file2>"
  abort msg
end
file1 = CSV.read(ARGV[2])
exit_if_empty(file1)
file2 = CSV.read(ARGV[3])
exit_if_empty(file2)

if ARGV[1].int?
  key_index = ARGV[1].to_i
  if (key_index < 0) || (key_index >= file1[0].length)
    abort 'Error: key_index out of bounds!'
  end
else
  abort 'Error: key_index must be an integer value!'
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
