module AsteriskDatabase
  class Parser
    DATABASE_KEY_VALUE_REGEX = /\A(\/\w+)+\s+:\s+(.*)\z/
    ESCAPE_SEQUENCE_REGEX = /\A\e\[\d;\d{1,2}(;\d{1,2})?m/

    # TODO: change this to host, key
    # so like 'fsa', 'CNAM'
    def initialize(
      database_key=nil,
      host='localhost',
      asterisk_bin: nil,
      ssh_kex_algorithm: nil
    )
      @database_key = database_key
      @host = host

      @asterisk_bin = asterisk_bin

      @ssh_options = {
        kex_algorithm: ssh_kex_algorithm
      }
    end

    # instance methods
    def parse
      result = ActiveSupport::HashWithIndifferentAccess.new
      state = nil
      keys = []
      current_key = ''
      current_value = ''
      number_of_keys = nil
      index = nil

      raw_output.lines.each do |line|
        line.gsub!(ESCAPE_SEQUENCE_REGEX, '')

        next unless line.start_with?('/')

        state = :looking_for_slash
        keys.clear
        current_value.clear

        line.strip.chars.each do |char|
          case state
          when :looking_for_slash
            case char
            when '/'
              # slash found
              state = :looking_for_key_name
            when ' '
              # lhs is done
              state = :looking_for_separator
            end
          when :looking_for_key_name
            case char
            when '/'
              # current_key is complete, look for next slash
              keys.push(current_key.clone)
              current_key.clear
              state = :looking_for_key_name
            when ' '
              # lhs is done
              keys.push(current_key.clone)
              current_key.clear
              state = :looking_for_separator
            else
              # char belongs to key
              current_key.concat(char)
            end
          when :looking_for_separator
            case char
            when ':'
              # separator found, look for rhs
              state = :looking_for_value
            end
          when :looking_for_value
            if char =~ /\A\s\z/
              # noop
            else
              # char belongs to value
              current_value.concat(char)
            end
          end
        end

        number_of_keys = keys.size
        index = 0
        keys.reduce(result) do |acc, sub_key|
          index += 1

          if index == number_of_keys
            acc[sub_key] = current_value
          else
            acc[sub_key] ||= ActiveSupport::HashWithIndifferentAccess.new
          end
        end
      end

      result
    end

    private

    def ssh_bin
      @ssh_bin ||= %x[which ssh].strip
    end

    def asterisk_bin
      @asterisk_bin || 'asterisk'
    end

    def ssh_option_string
      options = []

      if @ssh_options[:kex_algorithm]
        options.push("-oKexAlgorithms=+#{@ssh_options[:kex_algorithm]}")
      end

      options.join(' ')
    end

    def local?
      @host == 'localhost'
    end

    def raw_output
      if local?
        ''
      else
        %x[#{ssh_bin} #{ssh_option_string} #{@host} "#{asterisk_bin} -rx 'database show #{@database_key}'"].strip
      end
    end
  end
end
