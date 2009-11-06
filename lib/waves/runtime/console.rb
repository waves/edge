require 'waves/runtime/mocks'

module Waves

  class Console

    attr_accessor :options
    
    include Waves::Runtime
    
    def self.load( options={} )
      Object.instance_eval { include Waves::Mocks }
      new( options )
    end
    
    
    def initialize( options = {} )
      @options = options
      load # load the runtime
    end

  end

end
