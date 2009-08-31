require 'logger'
module Waves

  module Logger

    # Returns the object being used for output by the logger.
    def self.output
      @output ||= ( config[:output] or $stderr )
    end
    
    # Returns the active configuration for the logger.
    def self.config ; @config ||= Waves.config.log ; end
    
    # Returns the logging level used to filter logging events.
    def self.level ; @level ||= ::Logger.const_get( config[:level].to_s.upcase || 'INFO' ) ; end
    
    # Starts the logger, using the active configuration to initialize it.
    def self.start
      @log = config[:rotation] ?
        ::Logger.new( output, config[:rotation].to_sym ) :
        ::Logger.new( output )
      @log.level = level
      @log.datetime_format = "%Y-%m-%d %H:%M:%S "
      self
    end
    
    class << self
      extend Forwardable
      def_delegators :@log, *%w( debug info warn error )
    end

  end

end

