module Waves

  module Caches

    # A simple in-memory cache. This also serves as the base class
    # for all the Waves caching implementations, so that descendents
    # only need to override #initialize, #fetch, #store, #delete, and
    # #clear, since the other methods are defined in terms of those.
    class Simple
      
      def initialize( hash = {} ) ; @cache = hash ; end
      def [](key) ; fetch(key) ; end
      def []=( key, value ) ; store( key, value ) ; end
      def exists?( key ) ; fetch(key) == nil ? false : true ; end
      alias :exist? :exists?
      def store( key, val ) ; @cache[ key ] = val ; end
      def fetch( key ) ; @cache[ key ] ; end
      def delete( key ) ; @cache.delete( key ) ; end
      def clear ; @cache = {} ; end
      
    end
    
  end
end