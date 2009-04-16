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
      # of an extension.
      #
      # @todo Enforce MIME lookup success? --rue
      #
      def initialize(ext)
        raise ArgumentError, "No Ext constraints!" unless ext

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
