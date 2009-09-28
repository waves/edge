require 'redcloth'
module Waves
  module Helpers

    module Formatting

      # Treat content as Textile.
      def textile( content )
        raw ::RedCloth.new( content ).to_html
      end
      
    end
  end
end
