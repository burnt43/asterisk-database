require 'asterisk-database'
require 'active_support/core_ext/hash/indifferent_access'

parser = AsteriskDatabase::Parser.new(
  'CFV',
  'nb-mg0',
  asterisk_bin: '/usr/asterisk-1.6.1/sbin/asterisk'
)
puts parser.parse

=begin
config = {
  mg0: {
    asterisk_bin:      '/usr/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  mg1: {
    asterisk_bin:      '/usr/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  mg2: {
    asterisk_bin:      '/usr/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  mg3: {
    asterisk_bin:      '/usr/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  mg4: {
    asterisk_bin:      '/usr/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  mg5: {
    asterisk_bin:      '/usr/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  mg6: {
    asterisk_bin:      '/usr/sbin/asterisk'
  },
  :'pl-mg0' => {
    asterisk_bin:      '/usr/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  :'pl-mg1' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  :'cm-mg0' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  :'cm-mg1' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  },
  :'cm-mg2' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk'
  },
  :'nb-mg0' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk'
  },
  :'nb-mg1' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk'
  },
  :'nb-mg2' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk'
  },
  :'nb-mg3' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk'
  },
  :'nb-mg4' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk'
  },
  :'nb-mg5' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk'
  },
  :'nb-mg6' => {
    asterisk_bin:      '/usr/asterisk-1.6.1/sbin/asterisk'
  },
  fsa: {
    asterisk_bin:      '/usr/asterisk-1.4.17/sbin/asterisk',
    ssh_kex_algorithm: 'diffie-hellman-group1-sha1'
  }
}

config.slice(:'nb-mg0', :'nb-mg1', :'nb-mg2', :'nb-mg3', :'nb-mg4', :'nb-mg5', :'nb-mg6').each do |hostname, keyword_args|
  parser = AsteriskDatabase::Parser.new(
    'CNAM',
    hostname,
    **keyword_args
  )
  result = parser.parse
  if result
    puts "#{hostname}: \033[0;32mOK\033[0;0m"
  else
    puts "#{hostname}: \033[0;31mFAIL\033[0;0m"
  end
end
=end
