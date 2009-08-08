module Waves
  module Layers
    module Text
      
      # Originally based on English gem. That code was (a) deprecated,
      # (b) used confusing naming conventions (based on Rails original
      # names, like 'camelize' instead of 'camel_case'), and (c) was
      # not thread-safe (making use of $ variables in gsub).
      #
      module Helpers
        
        def self.included( target )
          String.class_eval { include self }
        end
      
        def lowercase
          downcase
        end
        alias_method :lower_case, :lowercase

        def uppercase
          upcase
        end
        alias_method :upper_case, :uppercase

        def titlecase
          gsub( /\b\w/ ) { |x| x.upcase }
        end
        alias_method :title_case, :titlecase

        # Just converts FooBar to foo_bar ...
        # if you want to also convert a FQN to
        # a path, use path in combination with
        # this ...
        def snakecase
          gsub( /^[A-Z]/) { |x| x.downcase }.
          gsub(/[A-Z]/) { |x| "_#{x.downcase}" }
        end
        alias_method :snake_case, :snakecase

        def camelcase( style => :upper )
          if style == :upper
            gsub(/^\w/) { |x| x.upcase }.gsub( /_\w/ ) { |x| x[1,1].upcase }
          else
            gsub(/^\w/) { |x| x.downcase }.gsub( /_\w/ ) { |x| x[1,1].upcase }
          end
        end
        alias_method :camel_case, :camelcase

        def ordinal
          gsub(/\d+$/) { |x|
            x = x.to_i
            if (11..13).include?(x % 100)
              "#{i}th"
            else
              case x % 10
                when 1; "#{x}st"
                when 2; "#{x}nd"
                when 3; "#{x}rd"
                else    "#{x}th"
              end
            end
          }
        end

        def path
          gsub(/::/, '/')
        end

        def basename
          gsub(/^.*::/, '')
        end
        
        def in_words
          gsub(%r{_|/}, ' ')
        end
        
      end

      end

    end
  end
end

