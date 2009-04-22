module Waves
  module Matchers

    class Ext < Base

      # Create file extension matcher.
      #
      # May be absent, in which case any or no extension is
      # accepted. Any specified extensions must be given as
      # Symbols without the dot.
      #
      # As a special case, if the extension Array contains
      # the empty String "", the matcher will match absence
      # of an extension. The empty String MUST NOT be by
      # itself.
      #
      # @todo Enforce MIME lookup success? --rue
      #
      def initialize(ext)
        raise ArgumentError, "No Ext constraints!" unless ext

        # @todo Ridiculous 1.8 semantics, Array uses #each if
        #       present, but delete works equally here. So it
        #       does not matter whether we have "" or [""] at
        #       this point, both work. This must change for
        #       1.9 compatibility. --rue

        ext = Array(ext)
        raise ArgumentError, "No Ext constraints!" if ext.empty?

        noext = ext.delete ""   # Absent extension
        ext.map! {|e| ".#{e.to_s}" }

        # @todo Could maybe drop an empty ext. --rue
        @constraints = {:ext => ext, :noext => noext}
      end

      # Match URL's file extension.
      #
      # @see  Ext#initialize for information.
      #
      def call(request)
        return @constraints[:noext] unless request.ext
        return @constraints[:ext].any? {|ext| ext == request.ext }
      end

    end

  end

end
