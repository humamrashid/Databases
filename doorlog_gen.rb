#!/usr/bin/ruby

# A generator for doorlog records, for insertion into the
# postgresql database.

def entry_or_exit
  x = rand(0..1)
  if x == 0
    return 'E'
  else
    return 'X'
  end
end

puts "create table doorlog(
  eventid varchar(18),
  doorid varchar(6),
  tim varchar(8),
  username varchar(20),
  even char(1)
);"

(0..10000).each do |i|
  puts "insert into doorlog values(#{rand(1..100)}, #{rand(1..20)}, \
    '#{rand(20000101..20201231)}', '#{rand(0..100000)}', '#{entry_or_exit}');"
end

# EOF.
