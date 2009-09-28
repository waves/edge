module Waves
  module Helpers
    module Basic
      
      # Escape a string as HTML content.
      def escape_html(s); Rack::Utils.escape_html(s); end

      # Escape a URI, converting quotes and spaces and so on.
      def escape_uri(s); Rack::Utils.escape(s); end

    end
  end
end