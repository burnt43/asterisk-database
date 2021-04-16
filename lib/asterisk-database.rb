module AsteriskDatabase
  class Parser
    DATABASE_KEY_VALUE_REGEX = /\A(\/\w+)+\s+:\s+(.*)\z/

    # TODO: change this to host, key
    # so like 'fsa', 'CNAM'
    def initialize(
      database_key=nil,
      host='localhost',
      asterisk_bin: nil,
      ssh_user: nil,
      ssh_identity_file: nil,
      ssh_kex_algorithm: nil
    )
      @database_key = database_key
      @host = host

      @asterisk_bin = asterisk_bin

      @ssh_options = {
        user: ssh_user,
        identity_file: ssh_identity_file,
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
        next unless line.start_with?('/')

        state = :looking_for_slash
        keys.clear
        current_value.clear

        # Parse the line. Looking for keys which are /-separated and finally
        # the value. For instance:
        #   /Key1/Key2/Key3: some_value.
        # The result would be:
        #   keys          == ['Key1', 'Key2', 'Key3']
        #   current_value == 'some_value'
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
            acc[sub_key] = current_value.clone
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

      if @ssh_options[:identity_file]
        options.push("-i #{@ssh_options[:identity_file]}")
      end

      if @ssh_options[:kex_algorithm]
        options.push("-oKexAlgorithms=+#{@ssh_options[:kex_algorithm]}")
      end

      options.join(' ')
    end

    def ssh_destination
      if @ssh_options[:user]
        "#{@ssh_options[:user]}@#{@host}"
      else
        @host
      end
    end

    def local?
      @host == 'localhost'
    end

    def raw_output
      if local?
        ''
      else
        %x[#{ssh_bin} #{ssh_option_string} #{ssh_destination} "#{asterisk_bin} -nrx 'database show #{@database_key}'"].strip
      end
    end
  end
end
