require 'cassandra'
module Waves
  module Helpers
    module Css
      attr_reader :request
      include Waves::ResponseMixin
      
      def css( &block ) ; ( @cssy ||= Cssy.new ).instance_eval( &block ); end
      
    end
  end
end