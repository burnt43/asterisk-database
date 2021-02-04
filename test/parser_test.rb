require './test/test_helper.rb'

class ParserTest < Minitest::Test
  def test_ssh_option_string
    parser_01 = AsteriskDatabase::Parser.new(
      'SOME_KEY'
    )
    assert_equal('', parser_01.send(:ssh_option_string))

    parser_02 = AsteriskDatabase::Parser.new(
      'SOME_KEY',
      ssh_kex_algorithm: 'fake-algo'
    )
    assert_equal('-oKexAlgorithms=+fake-algo', parser_02.send(:ssh_option_string))

    parser_03 = AsteriskDatabase::Parser.new(
      'SOME_KEY',
      ssh_identity_file: '/home/user/.ssh/id_rsa',
      ssh_kex_algorithm: 'fake-algo'
    )
    assert_equal('-i /home/user/.ssh/id_rsa -oKexAlgorithms=+fake-algo', parser_03.send(:ssh_option_string))

    parser_04 = AsteriskDatabase::Parser.new(
      'SOME_KEY',
      ssh_identity_file: '/home/user/.ssh/id_rsa'
    )
    assert_equal('-i /home/user/.ssh/id_rsa', parser_04.send(:ssh_option_string))
  end

  def test_ssh_destination
    parser_01 = AsteriskDatabase::Parser.new(
      'SOME_KEY',
    )
    assert_equal('localhost', parser_01.send(:ssh_destination))

    parser_02 = AsteriskDatabase::Parser.new(
      'SOME_KEY',
      'remote-host'
    )
    assert_equal('remote-host', parser_02.send(:ssh_destination))

    parser_03 = AsteriskDatabase::Parser.new(
      'SOME_KEY',
      'remote-host',
      ssh_user: 'somedude'
    )
    assert_equal('somedude@remote-host', parser_03.send(:ssh_destination))
  end
end
