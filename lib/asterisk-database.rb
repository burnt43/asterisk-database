module AsteriskDatabase
  class Parser
    DATABASE_KEY_VALUE_REGEX = /\A(\/\w+)+\s+:\s+(.*)\z/

    # TODO: change this to host, key
    # so like 'fsa', 'CNAM'
    def initialize(file_path)
      @file_path = file_path
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

      IO.read(@file_path).lines.each do |line|
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
  end
end
