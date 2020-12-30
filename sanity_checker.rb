require 'asterisk-database'
require 'active_support/core_ext/hash/indifferent_access'

parser = AsteriskDatabase::Parser.new(
  'CNAM',
  'fsa',
  asterisk_bin: '/usr/asterisk-1.4.17/sbin/asterisk',
  ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
)
puts parser.parse.to_s
