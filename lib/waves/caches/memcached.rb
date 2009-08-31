require 'memcached'
module Waves
  module Caches

    # A simple interface to Memcached. Pass in the memcached server to 
    # the constructor, like this:
    #
    #   Waves::Caches::Memcached.new( 'localhost:11211' )
    #
    # Memcached::NotFound is converted to nil, even though nil is, in fact,
    # a valid value to want to cache. Rather than force every use of the 
    # cache interface to add exception handling for the (relatively rare)
    # case where nil is an expected value, just code those cases using 
    # the #exists? method.
    #
    # This interface is not thread-safe. If you want to use this in apps
    # where you are handling requests in parallel, use SynchronizedMemcached.
    #
    class Memcached < Simple

      def initialize( args )
        raise ArgumentError, ":servers is nil" if args[ :servers ].nil?
        @cache = ::Memcached.new( args[ :servers ], args[ :options ] || {} )
      end

      def store( key, value, ttl = 0, marshal = true )
        @cache.add( key.to_s, value, ttl, marshal )
      end

      def fetch( key )
        @cache.get( key.to_s )
      rescue ::Memcached::NotFound => e
        nil
      end

      def delete( key )
        @cache.delete( key.to_s )
      end

      def clear
        @cache.flush
      end

    end
    
    # A thread-safe version of Memcached.
    class SynchronizedMemcached < Synchronized
      
      def initialize( args )
        super( Memcached.new( args ) )
      end
      
    end

  end
end