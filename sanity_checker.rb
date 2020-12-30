require 'asterisk-database'
require 'active_support/core_ext/hash/indifferent_access'

parser = AsteriskDatabase::Parser.new('/home/jcarson/.tmp/database_show_cnam.txt')
puts parser.parse
