
module Waves

  module Caches
    
    #
    # This is just a proxy for the real cache, but adds Waves synchronization. Pass the cache you
    # want to use when you create the cache.
    #
    
    class Synchronized
      
      def initialize( cache ) ; @cache = cache ; end
      def [](key) ; @cache.fetch(key) ; end
      def []=( key, value ) ; @cache.store( key, value ) ; end
      def exists?( key ) ; @cache.has_key?( key ) ; end
      alias :exist? :exists?
      def store( key, val ) ; synchronize { @cache.store( key, value ) }; end
      def fetch( keys ) ; @cache.fetch( key ) ; end
      def delete( key ) ; synchronize { @cache.delete( key ) } ; end
      def clear ; synchronize { @cache.clear } ; end
      def synchronize( &block ) ; Waves.synchronize( &block ) ; end
      
    end
    
    
    # A thread-safe version of the in-memory cache.
    class SynchronizedSimple < Synchronized
      
      def initialize( args )
        super( Simple.new( args ) )
      end
      
    end
    
    

  end
end